Imports System.Data



Public Class LeaveApproval
        Inherits System.Web.UI.Page

        Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
            If Not IsPostBack Then
                BindGrid()
            End If
        End Sub


    ' =========================================================
    ' GRID
    ' =========================================================

    'Private Sub BindGrid()

    '    ' TODO: replace with the real query, e.g.:
    '    ' Dim dt As DataTable = LeaveRepository.GetForApproval(ddlStatusFilter.SelectedValue)
    '    Dim dt As New DataTable()
    '    dt.Columns.Add("LeaveRequestId", GetType(Integer))
    '    dt.Columns.Add("EmpName", GetType(String))
    '    dt.Columns.Add("Department", GetType(String))
    '    dt.Columns.Add("LeaveType", GetType(String))
    '    dt.Columns.Add("FromDate", GetType(Date))
    '    dt.Columns.Add("ToDate", GetType(Date))
    '    dt.Columns.Add("TotalDays", GetType(Integer))
    '    dt.Columns.Add("Reason", GetType(String))
    '    dt.Columns.Add("Status", GetType(String))

    '    gvLeave.DataSource = dt
    '    gvLeave.DataBind()

    '    litResultCount.Text = dt.Rows.Count.ToString() & " request" & If(dt.Rows.Count = 1, "", "s")
    'End Sub

    Private Sub BindGrid()

        Dim dt As New DataTable()

        dt.Columns.Add("LeaveRequestId", GetType(Integer))
        dt.Columns.Add("EmpName", GetType(String))
        dt.Columns.Add("Department", GetType(String))
        dt.Columns.Add("LeaveType", GetType(String))
        dt.Columns.Add("FromDate", GetType(Date))
        dt.Columns.Add("ToDate", GetType(Date))
        dt.Columns.Add("TotalDays", GetType(Integer))
        dt.Columns.Add("Reason", GetType(String))
        dt.Columns.Add("Status", GetType(String))

        ' =========================================================
        ' DUMMY LEAVE REQUEST FOR APPROVAL
        ' =========================================================

        dt.Rows.Add(
        1001,
        "Rahul Sharma",
        "Production",
        "Casual Leave",
        New Date(2026, 10, 8),
        New Date(2026, 10, 10),
        3,
        "Personal work",
        "Pending"
    )

        gvLeave.DataSource = dt
        gvLeave.DataBind()

        litResultCount.Text = dt.Rows.Count.ToString() &
                          " request" &
                          If(dt.Rows.Count = 1, "", "s")

    End Sub
    Protected Sub ddlStatusFilter_Changed(sender As Object, e As EventArgs)
            gvLeave.PageIndex = 0
            BindGrid()
        End Sub


        Protected Sub gvLeave_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
            gvLeave.PageIndex = e.NewPageIndex
            BindGrid()
        End Sub


        Protected Sub gvLeave_RowCommand(sender As Object, e As GridViewCommandEventArgs)
            If e.CommandName = "Review" Then
                Dim leaveRequestId As Integer = Convert.ToInt32(e.CommandArgument)
                LoadRequestIntoDrawer(leaveRequestId)
                ReopenDrawerOnLoad()
            End If
        End Sub


        ' =========================================================
        ' DRAWER
        ' =========================================================

        Private Sub LoadRequestIntoDrawer(leaveRequestId As Integer)

            ' TODO: pull the real request, e.g.:
            ' Dim req As LeaveRequestDto = LeaveRepository.GetById(leaveRequestId)
            ' Also pull any day-level statuses already saved from a previous partial
            ' review, so re-opening a request shows prior unchecks, not a fresh list.

            hfLeaveRequestId.Value = leaveRequestId.ToString()
            litDrawerEmpName.Text = "Employee Name"            ' TODO: req.EmpName
            litDrawerDept.Text = "Department"                  ' TODO: req.Department
            litDrawerLeaveType.Text = "Casual Leave"            ' TODO: req.LeaveType
            litDrawerReason.Text = "Reason text here"           ' TODO: req.Reason
            txtRejectionReason.Text = String.Empty

            Dim fromDate As Date = Date.Today                  ' TODO: req.FromDate
            Dim toDate As Date = Date.Today.AddDays(1)          ' TODO: req.ToDate

            BindDayList(fromDate, toDate)
        End Sub


        ' builds one row per calendar day in the range, skipping weekends.
        ' this is the list the HOD checks/unchecks in the drawer.
        Private Sub BindDayList(fromDate As Date, toDate As Date)

            Dim days As New List(Of Object)

            Dim current As Date = fromDate
            While current <= toDate
                If current.DayOfWeek <> DayOfWeek.Saturday AndAlso current.DayOfWeek <> DayOfWeek.Sunday Then
                    days.Add(New With {
                        .IsoDate = current.ToString("yyyy-MM-dd"),
                        .DisplayDate = current.ToString("dd-MMM-yyyy (dddd)")
                    })
                End If
                current = current.AddDays(1)
            End While

            rptDays.DataSource = days
            rptDays.DataBind()
        End Sub


        ' =========================================================
        ' APPROVE / REJECT
        ' =========================================================

        Protected Sub btnApprove_Click(sender As Object, e As EventArgs)

            Dim leaveRequestId As Integer = Convert.ToInt32(hfLeaveRequestId.Value)

            Dim approvedDates As New List(Of String)
            Dim rejectedDates As New List(Of String)

            For Each item As RepeaterItem In rptDays.Items
                Dim chk As CheckBox = CType(item.FindControl("chkDay"), CheckBox)
                Dim hfDate As HiddenField = CType(item.FindControl("hfDayDate"), HiddenField)

                If chk.Checked Then
                    approvedDates.Add(hfDate.Value)
                Else
                    rejectedDates.Add(hfDate.Value)
                End If
            Next

            If rejectedDates.Count > 0 AndAlso String.IsNullOrWhiteSpace(txtRejectionReason.Text) Then
                lblDrawerMessage.CssClass = "alert-v1 alert-v1-danger mt-v1-3"
                lblDrawerMessage.Text = "Please give a reason for the day(s) you unchecked."
                ReopenDrawerOnLoad()
                Return
            End If

            If approvedDates.Count = 0 Then
                lblDrawerMessage.CssClass = "alert-v1 alert-v1-danger mt-v1-3"
                lblDrawerMessage.Text = "At least one day must stay checked to approve. Use Reject Request instead."
                ReopenDrawerOnLoad()
                Return
            End If

            ' TODO: persist this. Each date needs its own row/status, e.g. a
            ' LeaveRequestDates table (see schema note below):
            '
            ' For Each d In approvedDates
            '     LeaveRepository.SetDayStatus(leaveRequestId, d, "Approved")
            ' Next
            ' For Each d In rejectedDates
            '     LeaveRepository.SetDayStatus(leaveRequestId, d, "Rejected", txtRejectionReason.Text.Trim())
            ' Next
            '
            ' Dim overallStatus As String = If(rejectedDates.Count = 0, "Approved", "PartiallyApproved")
            ' LeaveRepository.SetRequestStatus(leaveRequestId, overallStatus, approvedDates.Count, CurrentUserId())
            ' LeaveRepository.AdjustBalance(leaveRequestId, approvedDates.Count)   ' credit back any rejected days

            BindGrid()
            ' drawer closes on success (no ReopenDrawerOnLoad call)
        End Sub


        Protected Sub btnReject_Click(sender As Object, e As EventArgs)

            Dim leaveRequestId As Integer = Convert.ToInt32(hfLeaveRequestId.Value)

            If String.IsNullOrWhiteSpace(txtRejectionReason.Text) Then
                lblDrawerMessage.CssClass = "alert-v1 alert-v1-danger mt-v1-3"
                lblDrawerMessage.Text = "A rejection reason is required."
                ReopenDrawerOnLoad()
                Return
            End If

            ' TODO: LeaveRepository.SetRequestStatus(leaveRequestId, "Rejected", 0, CurrentUserId(), txtRejectionReason.Text.Trim())
            ' TODO: LeaveRepository.AdjustBalance(leaveRequestId, 0)   ' credit the full amount back

            BindGrid()
        End Sub


        ' =========================================================
        ' HELPERS (also called from markup)
        ' =========================================================

        Protected Function FormatDate(value As Object) As String
            If value Is Nothing OrElse value Is DBNull.Value Then Return ""
            Return Convert.ToDateTime(value).ToString("dd-MMM-yyyy")
        End Function

        Protected Function StatusPillClass(status As String) As String
            Select Case status
                Case "Approved" : Return "pill-v1-approved"
                Case "PartiallyApproved" : Return "pill-v1-pending"
                Case "Rejected" : Return "pill-v1-rejected"
                Case Else : Return "pill-v1-pending"
            End Select
        End Function

    'Private Sub ReopenDrawerOnLoad()
    '    ClientScript.RegisterStartupScript(
    '        Me.GetType(),
    '        "reopenDrawer",
    '        "window.__reopenDrawer = true;",
    '        True)
    'End Sub
    Private Sub ReopenDrawerOnLoad()

        ClientScript.RegisterStartupScript(
            Me.GetType(),
            "openLeaveDrawer",
            "setTimeout(function(){ openDrawer(); }, 100);",
            True)

    End Sub

End Class

