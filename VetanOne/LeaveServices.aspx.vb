Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.IO
Imports System.Text
Imports System.Web.Script.Serialization

Public Class LeaveServices
    Inherits System.Web.UI.Page

    Private Const AttachFolder As String = "~/Uploads/LeaveDocs"
    Private Shared ReadOnly AttachExt As String() = {".pdf", ".jpg", ".jpeg", ".png", ".doc", ".docx"}
    Private Shared ReadOnly Inv As CultureInfo = CultureInfo.InvariantCulture
    Private Shared ReadOnly ValidViews As String() = {"hub", "apply", "requests", "approvals", "calendar"}

    ' Written into the page script as the BAL object: { "<leaveTypeId>": { name, left, total } }
    Protected BalanceJson As String = "{}"

    ' ---------------------------------------------------------------------
    ' page life cycle
    ' ---------------------------------------------------------------------

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        AppSession.RequireLogin()
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If AppSession.EmployeeId = 0 Then
            pnlNoEmployee.Visible = True
            pnlLeave.Visible = False
            Return
        End If

        If IsPostBack Then Return

        Try
            BindHandover()
        Catch ex As Exception
            UiHelper.ErrorBox(Me, "Could not load the page", Db.FriendlyMessage(ex))
        End Try

        ' landing view / message after a redirect (Post-Redirect-Get keeps refresh from re-submitting)
        Dim v = If(Request.QueryString("view"), "").ToLowerInvariant()
        If Array.IndexOf(ValidViews, v) >= 0 Then hfView.Value = v

        Select Case Request.QueryString("msg")
            Case "submitted" : UiHelper.Toast(Me, "success", "Leave request submitted.")
            Case "cancelled" : UiHelper.Toast(Me, "success", "Request cancelled.")
            Case "approved" : UiHelper.Toast(Me, "success", "Request approved.")
            Case "rejected" : UiHelper.Toast(Me, "success", "Request rejected.")
        End Select
    End Sub

    ' Everything shown is bound here, after the button handlers have run, so it always reflects the latest data.
    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        If Not pnlLeave.Visible Then Return
        Try
            BindAll()
        Catch ex As Exception
            UiHelper.ErrorBox(Me, "Could not load leave data", Db.FriendlyMessage(ex))
        End Try
    End Sub

    ' ---------------------------------------------------------------------
    ' binding
    ' ---------------------------------------------------------------------

    Private Sub BindHandover()
        Dim dt = Db.Table("usp_Lookup",
                          Db.P("@Kind", "EMPLOYEE"),
                          Db.P("@CompanyId", AppSession.CompanyId),
                          Db.P("@ExcludeId", AppSession.EmployeeId))
        ddlHandover.Items.Clear()
        ddlHandover.Items.Add(New ListItem("Select colleague", ""))
        For Each r As DataRow In dt.Rows
            ddlHandover.Items.Add(New ListItem(r("Name").ToString(), r("Id").ToString()))
        Next
    End Sub

    Private Sub BindAll()
        Dim empId = AppSession.EmployeeId
        Dim companyId = AppSession.CompanyId
        Dim role = AppSession.Role

        ' hub: balances + can-approve flag
        Dim hub = Db.Sets("usp_Leave_Hub", Db.P("@EmployeeId", empId), Db.P("@Role", role))
        Dim bal = hub.Tables(0)
        Dim canApprove = CBool(hub.Tables(1).Rows(0)("CanApprove"))

        rptBalance.DataSource = bal
        rptBalance.DataBind()

        Dim keep = ddlLeaveType.SelectedValue
        ddlLeaveType.Items.Clear()
        ddlLeaveType.Items.Add(New ListItem("Select leave type", ""))
        For Each r As DataRow In bal.Rows
            ddlLeaveType.Items.Add(New ListItem(r("LeaveName").ToString(), r("LeaveTypeId").ToString()))
        Next
        If keep <> "" AndAlso ddlLeaveType.Items.FindByValue(keep) IsNot Nothing Then ddlLeaveType.SelectedValue = keep

        BalanceJson = BuildBalanceJson(bal)

        ' my requests
        rptRequests.DataSource = Db.Table("usp_Leave_MyRequests", Db.P("@EmployeeId", empId))
        rptRequests.DataBind()

        ' approvals (Admin / HR: everyone; managers: their direct reports)
        phApprovalsTile.Visible = canApprove
        If canApprove Then
            Dim pending = Db.Table("usp_Leave_Approvals_List",
                                   Db.P("@ApproverEmployeeId", empId),
                                   Db.P("@CompanyId", companyId),
                                   Db.P("@Role", role))
            rptApprovals.DataSource = pending
            rptApprovals.DataBind()
            pnlNoApprovals.Visible = (pending.Rows.Count = 0)
            litPending.Text = If(pending.Rows.Count = 0, "Nothing pending", pending.Rows.Count & " pending your review")
        Else
            pnlNoApprovals.Visible = False
        End If

        ' team calendar: this week, Monday to Sunday
        Dim today = Date.Today
        Dim monday = today.AddDays(-((CInt(today.DayOfWeek) + 6) Mod 7))
        litWeek.Text = BuildWeek(monday, today,
            Db.Table("usp_Leave_TeamCalendar",
                     Db.P("@EmployeeId", empId), Db.P("@CompanyId", companyId),
                     Db.P("@Role", role), Db.P("@WeekStart", monday)))
    End Sub

    Private Shared Function BuildBalanceJson(bal As DataTable) As String
        Dim dict As New Dictionary(Of String, Object)
        For Each r As DataRow In bal.Rows
            dict(r("LeaveTypeId").ToString()) = New With {
                .name = r("LeaveName").ToString(),
                .left = CDec(r("Available")),
                .total = CDec(r("Allotted"))}
        Next
        Return New JavaScriptSerializer().Serialize(dict).Replace("<", "\u003c")     ' safe inside <script>
    End Function

    Private Shared Function BuildWeek(monday As Date, today As Date, leaves As DataTable) As String
        Dim sb As New StringBuilder("<div class=""week-grid"">")
        For i As Integer = 0 To 6
            Dim d = monday.AddDays(i)
            Dim isSunday = (d.DayOfWeek = DayOfWeek.Sunday)
            Dim css = "day-col" & If(d = today, " today", "") & If(isSunday, " weekend", "")

            sb.Append("<div class=""" & css & """><div class=""day-name"">" & d.ToString("ddd", Inv) & "</div>")
            sb.Append("<div class=""day-num"">" & d.Day & "</div>")

            Dim any As Boolean = False
            For Each r As DataRow In leaves.Rows
                If CDate(r("FromDate")) <= d AndAlso CDate(r("ToDate")) >= d Then
                    any = True
                    Dim name = r("EmployeeName").ToString()
                    Dim half = If(CBool(r("IsHalfDay")), " (half day)", "")
                    sb.Append("<div class=""out-chip""><span class=""avatar-v1 avatar-v1-sm"">" & HttpUtility.HtmlEncode(Initials(name)) &
                              "</span><span>" & HttpUtility.HtmlEncode(name & half) & "</span></div>")
                End If
            Next
            If Not any Then sb.Append("<div class=""day-empty"">" & If(isSunday, "Weekly off", "Nobody out") & "</div>")
            sb.Append("</div>")
        Next
        sb.Append("</div>")
        Return sb.ToString()
    End Function

    ' ---------------------------------------------------------------------
    ' formatting helpers used by the markup
    ' ---------------------------------------------------------------------

    Protected Shared Function Num(o As Object) As String
        Dim d = Convert.ToDecimal(o, Inv)
        Return If(d = Math.Floor(d), d.ToString("0", Inv), d.ToString("0.0", Inv))
    End Function

    Protected Shared Function Pct(available As Object, allotted As Object) As String
        Dim a = Convert.ToDecimal(allotted, Inv)
        If a <= 0D Then Return "0"
        Dim p = Math.Max(0D, Math.Min(100D, Convert.ToDecimal(available, Inv) / a * 100D))
        Return Math.Round(p, 1).ToString("0.#", Inv)
    End Function

    Protected Shared Function Period(fromDate As Object, toDate As Object, isHalf As Object) As String
        Dim f = Convert.ToDateTime(fromDate)
        Dim t = Convert.ToDateTime(toDate)
        Dim dash = " " & ChrW(8211) & " "
        Dim s = If(f = t, f.ToString("dd MMM yyyy", Inv), f.ToString("dd MMM", Inv) & dash & t.ToString("dd MMM yyyy", Inv))
        If Convert.ToBoolean(isHalf) Then s &= " (half day)"
        Return s
    End Function

    Protected Shared Function PillClass(statusKey As Object) As String
        Select Case Convert.ToString(statusKey)
            Case "pending" : Return "pill-v1-pending"
            Case "approved" : Return "pill-v1-approved"
            Case "rejected" : Return "pill-v1-rejected"
            Case Else : Return "pill-v1-neutral"
        End Select
    End Function

    Protected Shared Function ActionButton(statusKey As Object, requestId As Object, reason As Object, remarks As Object) As String
        If Convert.ToString(statusKey) = "pending" Then
            Return "<button type=""button"" class=""btn-v1-icon danger js-cancel"" data-id=""" & Convert.ToInt32(requestId) &
                   """ title=""Cancel request""><i class=""bi bi-x-lg""></i></button>"
        End If
        Return "<button type=""button"" class=""btn-v1-icon js-view"" data-reason=""" & HttpUtility.HtmlAttributeEncode(Convert.ToString(reason)) &
               """ data-remarks=""" & HttpUtility.HtmlAttributeEncode(Convert.ToString(remarks)) &
               """ title=""View details""><i class=""bi bi-eye""></i></button>"
    End Function

    Protected Shared Function Initials(name As Object) As String
        Dim parts = Convert.ToString(name).Split(New Char() {" "c}, StringSplitOptions.RemoveEmptyEntries)
        If parts.Length = 0 Then Return "?"
        If parts.Length = 1 Then Return parts(0).Substring(0, 1).ToUpperInvariant()
        Return (parts(0).Substring(0, 1) & parts(1).Substring(0, 1)).ToUpperInvariant()
    End Function

    Private Shared Function ParseDate(text As String) As Object
        Dim d As DateTime
        If DateTime.TryParseExact(text, "yyyy-MM-dd", Inv, DateTimeStyles.None, d) Then Return d
        Return Nothing
    End Function

    ' ---------------------------------------------------------------------
    ' actions
    ' ---------------------------------------------------------------------

    ' Submit request (step 3 of Apply for leave)
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        hfView.Value = "apply"

        Dim leaveTypeId As Integer
        Dim fromDate = ParseDate(txtFrom.Text)
        Dim toDate = ParseDate(txtTo.Text)
        If Not Integer.TryParse(ddlLeaveType.SelectedValue, leaveTypeId) OrElse fromDate Is Nothing OrElse toDate Is Nothing Then
            UiHelper.Toast(Me, "warning", "Choose the leave type and both dates.")
            Return
        End If

        Dim attachPath As String = Nothing
        Dim attachName As Object = Nothing
        Try
            If fuAttach.HasFile Then
                attachPath = FileStore.Save(fuAttach.PostedFile, AttachFolder, AttachExt, 5 * 1024 * 1024)
                attachName = Db.Txt(Path.GetFileName(fuAttach.FileName), 200)
            End If
        Catch ex As InvalidOperationException
            UiHelper.Toast(Me, "warning", ex.Message)
            Return
        End Try

        Dim requestId = Db.OutInt("@RequestId")
        Try
            Db.NonQuery("usp_Leave_Apply",
                Db.P("@EmployeeId", AppSession.EmployeeId),
                Db.P("@LeaveTypeId", leaveTypeId),
                Db.P("@FromDate", fromDate),
                Db.P("@ToDate", toDate),
                Db.P("@IsHalfDay", chkHalf.Checked),
                Db.P("@HalfSession", If(chkHalf.Checked, ddlHalf.SelectedValue, Nothing)),
                Db.P("@Reason", Db.Txt(txtReason.Text, 300)),
                Db.P("@ContactNo", Db.Txt(txtContact.Text, 15)),
                Db.P("@HandoverEmployeeId", Db.IntOrNull(ddlHandover.SelectedValue)),
                Db.P("@AttachmentName", attachName),
                Db.P("@AttachmentPath", attachPath),
                requestId)

            Response.Redirect("LeaveServices.aspx?view=requests&msg=submitted", False)

        Catch ex As SqlException
            FileStore.DeleteQuietly(attachPath)
            UiHelper.ErrorBox(Me, "Could not submit the request", Db.FriendlyMessage(ex))
        End Try
    End Sub

    ' Cancel one of my own pending requests
    Protected Sub btnCancelReq_Click(sender As Object, e As EventArgs)
        hfView.Value = "requests"

        Dim id As Integer
        If Not Integer.TryParse(hfCancelId.Value, id) Then Return

        Try
            Db.NonQuery("usp_Leave_Cancel", Db.P("@RequestId", id), Db.P("@EmployeeId", AppSession.EmployeeId))
            Response.Redirect("LeaveServices.aspx?view=requests&msg=cancelled", False)
        Catch ex As SqlException
            UiHelper.ErrorBox(Me, "Could not cancel the request", Db.FriendlyMessage(ex))
        End Try
    End Sub

    ' Approve / reject from the Approvals view
    Protected Sub btnDecision_Click(sender As Object, e As EventArgs)
        hfView.Value = "approvals"

        Dim id As Integer
        If Not Integer.TryParse(hfReqId.Value, id) Then Return

        Dim approve = String.Equals(hfAction.Value, "approve", StringComparison.OrdinalIgnoreCase)
        Dim reject = String.Equals(hfAction.Value, "reject", StringComparison.OrdinalIgnoreCase)
        If Not approve AndAlso Not reject Then Return

        Try
            Db.NonQuery("usp_Leave_Decide",
                Db.P("@RequestId", id),
                Db.P("@ApproverUserId", AppSession.UserId),
                Db.P("@ApproverEmployeeId", AppSession.EmployeeId),
                Db.P("@CompanyId", AppSession.CompanyId),
                Db.P("@Role", AppSession.Role),
                Db.P("@Action", If(approve, "A", "R")),
                Db.P("@Remarks", Db.Txt(hfRemarks.Value, 300)))

            Response.Redirect("LeaveServices.aspx?view=approvals&msg=" & If(approve, "approved", "rejected"), False)

        Catch ex As SqlException
            UiHelper.ErrorBox(Me, "Could not record the decision", Db.FriendlyMessage(ex))
        End Try
    End Sub

End Class
