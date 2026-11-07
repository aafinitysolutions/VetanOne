Imports System.Data
Imports System.Data.SqlClient
Imports System.Globalization
Imports System.IO

Public Class EmployeeMaster
    Inherits System.Web.UI.Page

    Private Const PhotoFolder As String = "~/Uploads/Photos"
    Private Const DocFolder As String = "~/Uploads/EmployeeDocs"
    Private Shared ReadOnly PhotoExt As String() = {".jpg", ".jpeg", ".png"}
    Private Shared ReadOnly DocExt As String() = {".pdf", ".jpg", ".jpeg", ".png", ".doc", ".docx"}

    ' ---------------------------------------------------------------------
    ' state
    ' ---------------------------------------------------------------------

    Private ReadOnly Property EmployeeId As Integer
        Get
            Dim n As Integer
            Return If(Integer.TryParse(hfEmployeeId.Value, n), n, 0)
        End Get
    End Property

    ' Server-stored photo (virtual path), kept across postbacks. Used by the markup.
    Private Property PhotoVirtualPath As String
        Get
            Return If(ViewState("PhotoPath"), "").ToString()
        End Get
        Set(value As String)
            ViewState("PhotoPath") = value
        End Set
    End Property

    Protected ReadOnly Property PhotoBoxClass As String
        Get
            Return If(PhotoVirtualPath <> "", "has-img", "")
        End Get
    End Property

    Protected ReadOnly Property PhotoSrcAttr As String
        Get
            If PhotoVirtualPath = "" Then Return ""
            Return "src=""" & Server.HtmlEncode(ResolveUrl(PhotoVirtualPath)) & """"
        End Get
    End Property

    ' ---------------------------------------------------------------------
    ' page life cycle
    ' ---------------------------------------------------------------------

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        AppSession.RequireLogin()
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If IsPostBack Then Return

        Try
            BindStaticLookups()

            Dim id As Integer
            If Integer.TryParse(Request.QueryString("id"), id) AndAlso id > 0 Then
                LoadEmployee(id)
            Else
                ApplyNewEmployeeDefaults()
            End If

            Select Case Request.QueryString("saved")
                Case "1" : UiHelper.Toast(Me, "success", "Employee saved.")
                Case "2" : UiHelper.Toast(Me, "success", "Employee saved. You can add the next one.")
            End Select

        Catch ex As Exception
            UiHelper.ErrorBox(Me, "Could not load the page", Db.FriendlyMessage(ex))
        End Try
    End Sub

    ' ---------------------------------------------------------------------
    ' dropdowns
    ' ---------------------------------------------------------------------

    Private Function Lookup(kind As String, Optional companyId As Integer = 0, Optional parentId As Integer = 0, Optional excludeId As Integer = 0) As DataTable
        Return Db.Table("usp_Lookup",
                        Db.P("@Kind", kind),
                        Db.P("@CompanyId", Db.IdOrNull(companyId)),
                        Db.P("@ParentId", Db.IdOrNull(parentId)),
                        Db.P("@ExcludeId", Db.IdOrNull(excludeId)))
    End Function

    Private Shared Sub Fill(ddl As DropDownList, dt As DataTable, placeholder As String)
        ddl.Items.Clear()
        ddl.Items.Add(New ListItem(placeholder, ""))
        For Each r As DataRow In dt.Rows
            ddl.Items.Add(New ListItem(r("Name").ToString(), r("Id").ToString()))
        Next
    End Sub

    Private Shared Sub Pick(ddl As DropDownList, value As Object)
        ddl.ClearSelection()
        If value Is Nothing OrElse IsDBNull(value) Then Return
        Dim li = ddl.Items.FindByValue(value.ToString().Trim())
        If li IsNot Nothing Then li.Selected = True
    End Sub

    Private Shared Function SelectedId(ddl As DropDownList) As Integer
        Dim n As Integer
        Return If(Integer.TryParse(ddl.SelectedValue, n), n, 0)
    End Function

    Private Sub BindStaticLookups()
        Dim companyId = AppSession.CompanyId

        ' the logged-in user's company only
        Dim companies = Db.Table("usp_Company_List", Db.P("@CompanyId", companyId))
        ddlCompany.Items.Clear()
        For Each r As DataRow In companies.Rows
            ddlCompany.Items.Add(New ListItem(r("CompanyName").ToString(), r("CompanyId").ToString()))
        Next

        Fill(ddlBranch, Lookup("BRANCH", companyId), "Select")
        Fill(ddlDepartment, Lookup("DEPARTMENT", companyId), "Select")
        Fill(ddlDesignation, Lookup("DESIGNATION", companyId), "Select")
        Fill(ddlReportingTo, Lookup("EMPLOYEE", companyId, 0, EmployeeId), "Select")
        Fill(ddlCountry, Lookup("COUNTRY"), "Select")
        Fill(ddlState, New DataTable(), "Select")
        Fill(ddlBank, Lookup("BANK"), "Select bank")
    End Sub

    Private Sub BindStates(countryId As Integer)
        If countryId = 0 Then
            Fill(ddlState, New DataTable(), "Select")
        Else
            Fill(ddlState, Lookup("STATE", 0, countryId), "Select")
        End If
    End Sub

    Protected Sub ddlCountry_SelectedIndexChanged(sender As Object, e As EventArgs)
        BindStates(SelectedId(ddlCountry))
    End Sub

    Private Sub ApplyNewEmployeeDefaults()
        hfEmployeeId.Value = "0"
        lblMode.Text = "New employee"

        Dim india = ddlCountry.Items.FindByText("India")
        If india IsNot Nothing Then
            ddlCountry.ClearSelection()
            india.Selected = True
            BindStates(SelectedId(ddlCountry))
        End If

        BindDocs()
    End Sub

    ' ---------------------------------------------------------------------
    ' load
    ' ---------------------------------------------------------------------

    Private Shared Function T(o As Object) As String
        Return If(o Is Nothing OrElse IsDBNull(o), "", o.ToString())
    End Function

    Private Shared Function D(o As Object) As String
        Return If(o Is Nothing OrElse IsDBNull(o), "", CDate(o).ToString("yyyy-MM-dd", CultureInfo.InvariantCulture))
    End Function

    Private Sub LoadEmployee(id As Integer)
        Dim dt = Db.Table("usp_Employee_Get", Db.P("@EmployeeId", id))

        ' only employees of the logged-in user's company can be opened
        If dt.Rows.Count = 0 OrElse CInt(dt.Rows(0)("CompanyId")) <> AppSession.CompanyId Then
            UiHelper.Toast(Me, "warning", "That employee was not found.")
            ApplyNewEmployeeDefaults()
            Return
        End If

        Dim r = dt.Rows(0)
        hfEmployeeId.Value = id.ToString()

        ' the reporting-to list must not offer the employee themselves
        Fill(ddlReportingTo, Lookup("EMPLOYEE", AppSession.CompanyId, 0, id), "Select")

        txtEmpCode.Text = T(r("EmployeeCode"))
        txtEmpName.Text = T(r("EmployeeName"))
        txtFatherSpouse.Text = T(r("FatherSpouse"))
        txtDOB.Text = D(r("DateOfBirth"))
        Pick(ddlGender, r("Gender"))
        Pick(ddlMarital, r("MaritalStatus"))
        Pick(ddlBloodGroup, r("BloodGroup"))
        txtMobile.Text = T(r("Mobile"))
        txtEmail.Text = T(r("Email"))
        txtPAN.Text = T(r("PAN"))
        txtAadhaar.Text = T(r("Aadhaar"))
        txtUAN.Text = T(r("UAN"))
        PhotoVirtualPath = T(r("PhotoPath"))

        Pick(ddlCompany, r("CompanyId"))
        Pick(ddlBranch, r("BranchId"))
        Pick(ddlDepartment, r("DepartmentId"))
        Pick(ddlDesignation, r("DesignationId"))
        Pick(ddlEmpType, r("EmployeeType"))
        Pick(ddlReportingTo, r("ReportingToId"))
        txtDOJ.Text = D(r("DateOfJoining"))
        txtConfirmDate.Text = D(r("ConfirmationDate"))

        txtPresentAddr.Text = T(r("PresentAddress"))
        txtPermanentAddr.Text = T(r("PermanentAddress"))

        Pick(ddlCountry, r("CountryId"))
        BindStates(SelectedId(ddlCountry))
        Pick(ddlState, r("StateId"))
        txtLanguages.Text = T(r("LanguagesKnown"))
        Pick(ddlStatus, r("Status"))
        txtCTC.Text = If(IsDBNull(r("CTC")), "", CDec(r("CTC")).ToString("0.##", CultureInfo.InvariantCulture))
        chkPF.Checked = CBool(r("PFApplicable"))
        chkESIC.Checked = CBool(r("ESICApplicable"))
        chkPT.Checked = CBool(r("PTApplicable"))
        chkLWF.Checked = CBool(r("LWFApplicable"))
        chkOT.Checked = CBool(r("OTApplicable"))

        Pick(ddlBank, r("BankId"))
        txtBranch.Text = T(r("BankBranch"))
        txtAccountNo.Text = T(r("AccountNo"))
        txtIFSC.Text = T(r("IFSC"))

        lblMode.Text = "Editing " & T(r("EmployeeCode")) & " - " & T(r("EmployeeName"))
        BindDocs()
    End Sub

    ' ---------------------------------------------------------------------
    ' save
    ' ---------------------------------------------------------------------

    Private Shared Function ParseDate(text As String) As Object
        Dim d As DateTime
        If DateTime.TryParseExact(text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, d) Then Return d
        Return Nothing
    End Function

    ''' <summary>Returns the saved EmployeeId, or 0 if nothing was saved (a message has already been shown).</summary>
    Private Function SaveEmployee() As Integer
        Dim doj = ParseDate(txtDOJ.Text)
        Dim conf = ParseDate(txtConfirmDate.Text)
        If doj Is Nothing OrElse conf Is Nothing Then
            UiHelper.Toast(Me, "warning", "Enter valid joining and confirmation dates.")
            Return 0
        End If

        Dim ctc As Object = Nothing
        If Not String.IsNullOrWhiteSpace(txtCTC.Text) Then
            Dim amount As Decimal
            If Not Decimal.TryParse(txtCTC.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, amount) OrElse amount < 0 Then
                UiHelper.Toast(Me, "warning", "CTC must be a valid amount.")
                Return 0
            End If
            ctc = amount
        End If

        Dim photoPath As String = Nothing
        Try
            If fuPhoto.HasFile Then photoPath = FileStore.Save(fuPhoto.PostedFile, PhotoFolder, PhotoExt, 2 * 1024 * 1024)
        Catch ex As InvalidOperationException
            UiHelper.Toast(Me, "warning", ex.Message)
            Return 0
        End Try

        Dim idParam = Db.InOutInt("@EmployeeId", EmployeeId)
        Try
            Db.NonQuery("usp_Employee_Save",
                idParam,
                Db.P("@CompanyId", SelectedId(ddlCompany)),
                Db.P("@EmployeeCode", Db.Txt(txtEmpCode.Text, 20)),
                Db.P("@EmployeeName", Db.Txt(txtEmpName.Text, 100)),
                Db.P("@FatherSpouse", Db.Txt(txtFatherSpouse.Text, 100)),
                Db.P("@DateOfBirth", ParseDate(txtDOB.Text)),
                Db.P("@Gender", ddlGender.SelectedValue),
                Db.P("@MaritalStatus", Db.Txt(ddlMarital.SelectedValue, 1)),
                Db.P("@BloodGroup", Db.Txt(ddlBloodGroup.SelectedValue, 5)),
                Db.P("@Mobile", Db.Txt(txtMobile.Text, 15)),
                Db.P("@Email", Db.Txt(txtEmail.Text, 100)),
                Db.P("@PAN", Db.Txt(txtPAN.Text, 10)),
                Db.P("@Aadhaar", Db.Txt(txtAadhaar.Text, 12)),
                Db.P("@UAN", Db.Txt(txtUAN.Text, 12)),
                Db.P("@PhotoPath", photoPath),
                Db.P("@BranchId", Db.IntOrNull(ddlBranch.SelectedValue)),
                Db.P("@DepartmentId", SelectedId(ddlDepartment)),
                Db.P("@DesignationId", SelectedId(ddlDesignation)),
                Db.P("@EmployeeType", ddlEmpType.SelectedValue),
                Db.P("@ReportingToId", Db.IntOrNull(ddlReportingTo.SelectedValue)),
                Db.P("@DateOfJoining", doj),
                Db.P("@ConfirmationDate", conf),
                Db.P("@PresentAddress", Db.Txt(txtPresentAddr.Text, 300)),
                Db.P("@PermanentAddress", Db.Txt(txtPermanentAddr.Text, 300)),
                Db.P("@CountryId", Db.IntOrNull(ddlCountry.SelectedValue)),
                Db.P("@StateId", Db.IntOrNull(ddlState.SelectedValue)),
                Db.P("@LanguagesKnown", Db.Txt(txtLanguages.Text, 100)),
                Db.P("@Status", ddlStatus.SelectedValue),
                Db.P("@CTC", ctc),
                Db.P("@PFApplicable", chkPF.Checked),
                Db.P("@ESICApplicable", chkESIC.Checked),
                Db.P("@PTApplicable", chkPT.Checked),
                Db.P("@LWFApplicable", chkLWF.Checked),
                Db.P("@OTApplicable", chkOT.Checked),
                Db.P("@BankId", SelectedId(ddlBank)),
                Db.P("@BankBranch", Db.Txt(txtBranch.Text, 100)),
                Db.P("@AccountNo", Db.Txt(txtAccountNo.Text, 20)),
                Db.P("@IFSC", Db.Txt(txtIFSC.Text, 11)),
                Db.P("@UserId", Db.IdOrNull(AppSession.UserId)))

            Return CInt(idParam.Value)

        Catch ex As SqlException
            If photoPath IsNot Nothing Then FileStore.DeleteQuietly(photoPath)     ' don't leave an orphan upload behind
            UiHelper.ErrorBox(Me, "Could not save the employee", Db.FriendlyMessage(ex))
            Return 0
        End Try
    End Function

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return
        Dim id = SaveEmployee()
        If id > 0 Then Response.Redirect("EmployeeMaster.aspx?id=" & id & "&saved=1", False)
    End Sub

    Protected Sub btnSaveNew_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return
        Dim id = SaveEmployee()
        If id > 0 Then Response.Redirect("EmployeeMaster.aspx?saved=2", False)
    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
        Response.Redirect("Dashboard.aspx", False)
    End Sub

    ' ---------------------------------------------------------------------
    ' find
    ' ---------------------------------------------------------------------

    Protected Sub btnFind_Click(sender As Object, e As EventArgs)
        Dim term = txtFind.Text.Trim()
        If term = "" Then Return

        Dim o = Db.Scalar("usp_Employee_Find", Db.P("@CompanyId", AppSession.CompanyId), Db.P("@Term", term))
        If o Is Nothing OrElse IsDBNull(o) Then
            UiHelper.Toast(Me, "warning", "No employee matches """ & term & """.")
            Return
        End If
        Response.Redirect("EmployeeMaster.aspx?id=" & CInt(o), False)
    End Sub

    ' ---------------------------------------------------------------------
    ' documents
    ' ---------------------------------------------------------------------

    Private Sub BindDocs()
        gvDocs.DataSource = Db.Table("usp_EmployeeDocument_List", Db.P("@EmployeeId", EmployeeId))
        gvDocs.DataBind()
    End Sub

    Protected Sub btnAddDoc_Click(sender As Object, e As EventArgs)
        hfTab.Value = "tabDocs"

        If EmployeeId = 0 Then
            UiHelper.Toast(Me, "warning", "Save the employee first, then add documents.")
            Return
        End If
        If Not fuDocument.HasFile Then
            UiHelper.Toast(Me, "warning", "Choose a file to upload.")
            Return
        End If

        Dim path As String = Nothing
        Try
            path = FileStore.Save(fuDocument.PostedFile, DocFolder, DocExt, 5 * 1024 * 1024)
            Db.NonQuery("usp_EmployeeDocument_Add",
                        Db.P("@EmployeeId", EmployeeId),
                        Db.P("@DocType", ddlDocType.SelectedValue),
                        Db.P("@FileName", Db.Txt(System.IO.Path.GetFileName(fuDocument.FileName), 200)),
                        Db.P("@FilePath", path),
                        Db.P("@UploadedBy", Db.IdOrNull(AppSession.UserId)))
            BindDocs()
            UiHelper.Toast(Me, "success", "Document added.")

        Catch ex As InvalidOperationException
            UiHelper.Toast(Me, "warning", ex.Message)
        Catch ex As SqlException
            FileStore.DeleteQuietly(path)
            UiHelper.ErrorBox(Me, "Could not add the document", Db.FriendlyMessage(ex))
        End Try
    End Sub

    Protected Sub gvDocs_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        hfTab.Value = "tabDocs"

        Dim docId As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), docId) Then Return

        Try
            Select Case e.CommandName
                Case "ViewDoc"
                    DownloadDocument(docId)
                Case "DeleteDoc"
                    Dim o = Db.Scalar("usp_EmployeeDocument_Delete", Db.P("@DocumentId", docId), Db.P("@EmployeeId", EmployeeId))
                    If o IsNot Nothing AndAlso Not IsDBNull(o) Then FileStore.DeleteQuietly(o.ToString())
                    BindDocs()
                    UiHelper.Toast(Me, "success", "Document deleted.")
            End Select
        Catch ex As SqlException
            UiHelper.ErrorBox(Me, "Could not complete that action", Db.FriendlyMessage(ex))
        End Try
    End Sub

    Private Sub DownloadDocument(docId As Integer)
        Dim dt = Db.Table("usp_EmployeeDocument_Get", Db.P("@DocumentId", docId), Db.P("@EmployeeId", EmployeeId))
        If dt.Rows.Count = 0 Then Return

        Dim vpath = dt.Rows(0)("FilePath").ToString()
        If Not vpath.StartsWith("~/Uploads/", StringComparison.OrdinalIgnoreCase) Then Return

        Dim phys = Server.MapPath(vpath)
        If Not File.Exists(phys) Then
            UiHelper.Toast(Me, "warning", "The file is missing on the server.")
            Return
        End If

        Response.Clear()
        Response.ContentType = "application/octet-stream"
        Response.AddHeader("Content-Disposition", "attachment; filename*=UTF-8''" & Uri.EscapeDataString(dt.Rows(0)("FileName").ToString()))
        Response.TransmitFile(phys)
        Response.Flush()
        Context.ApplicationInstance.CompleteRequest()
    End Sub

End Class
