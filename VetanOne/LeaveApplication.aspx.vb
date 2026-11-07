Imports System
Imports System.Data
Imports System.Web.UI.WebControls

Partial Class LeaveApplication
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then

            pnlApplyLeave.Visible = True
            pnlLeaveReport.Visible = False

            lnkApplyLeave.CssClass = "leave-tab active"
            lnkLeaveReport.CssClass = "leave-tab"

            LoadLeaveTypes()
            LoadEmployeeInformation()
            LoadLeaveBalance()
            LoadLeaveReport()

        End If

    End Sub


    '===============================
    ' APPLY LEAVE TAB
    '===============================

    Protected Sub lnkApplyLeave_Click(
        sender As Object,
        e As EventArgs)

        pnlApplyLeave.Visible = True
        pnlLeaveReport.Visible = False

        lnkApplyLeave.CssClass = "leave-tab active"
        lnkLeaveReport.CssClass = "leave-tab"

    End Sub


    '===============================
    ' LEAVE REPORT TAB
    '===============================

    Protected Sub lnkLeaveReport_Click(
        sender As Object,
        e As EventArgs)

        pnlApplyLeave.Visible = False
        pnlLeaveReport.Visible = True

        lnkApplyLeave.CssClass = "leave-tab"
        lnkLeaveReport.CssClass = "leave-tab active"

    End Sub


    '===============================
    ' LEAVE TYPES
    '===============================

    Private Sub LoadLeaveTypes()

        ddlLeaveType.Items.Clear()

        ddlLeaveType.Items.Add(
            New ListItem("-- Select Leave Type --", "")
        )

        ddlLeaveType.Items.Add(
            New ListItem("Casual Leave (CL)", "CL")
        )

        ddlLeaveType.Items.Add(
            New ListItem("Sick Leave (SL)", "SL")
        )

        ddlLeaveType.Items.Add(
            New ListItem("Earned Leave (EL)", "EL")
        )

        ddlLeaveType.Items.Add(
            New ListItem("Maternity Leave", "ML")
        )

    End Sub


    '===============================
    ' EMPLOYEE INFORMATION
    '===============================

    Private Sub LoadEmployeeInformation()

        lblEmployee.Text = "EMP001 - Vijay Pandey"
        lblDepartment.Text = "IT"
        lblDesignation.Text = "Team Leader"
        lblJoiningDate.Text = "01-Jan-2010"

    End Sub


    '===============================
    ' LEAVE BALANCE
    '===============================

    Private Sub LoadLeaveBalance()

        Dim dt As New DataTable()

        dt.Columns.Add("LeaveTypeName")
        dt.Columns.Add("Allocated")
        dt.Columns.Add("Used")
        dt.Columns.Add("Balance")

        dt.Rows.Add("Casual Leave (CL)", 12, 3, 9)
        dt.Rows.Add("Sick Leave (SL)", 10, 2, 8)
        dt.Rows.Add("Earned Leave (EL)", 20, 5, 15)
        dt.Rows.Add("Maternity Leave", 26, 0, 26)

        gvLeaveBalance.DataSource = dt
        gvLeaveBalance.DataBind()

    End Sub


    '===============================
    ' SAVE - FRONTEND ONLY
    '===============================

    Protected Sub btnSave_Click(
        sender As Object,
        e As EventArgs)

        lblMessage.Text =
            "Leave application saved successfully."

        lblMessage.CssClass =
            "text-success d-block mt-3"

    End Sub


    '===============================
    ' SAVE & NEW
    '===============================

    Protected Sub btnSaveNew_Click(
        sender As Object,
        e As EventArgs)

        lblMessage.Text =
            "Leave application saved successfully."

        lblMessage.CssClass =
            "text-success d-block mt-3"

        ClearForm()

    End Sub


    '===============================
    ' CLEAR
    '===============================

    Protected Sub btnClear_Click(
        sender As Object,
        e As EventArgs)

        ClearForm()

    End Sub


    Private Sub ClearForm()

        ddlLeaveType.SelectedIndex = 0

        txtFromDate.Text = ""
        txtToDate.Text = ""

        txtTotalLeave.Text = "0"

        txtReason.Text = ""

        lblMessage.Text = ""

    End Sub


    '===============================
    ' CANCEL
    '===============================

    Protected Sub btnCancel_Click(
        sender As Object,
        e As EventArgs)

        ClearForm()

    End Sub


    '===============================
    ' REPORT SEARCH
    ' FRONTEND SAMPLE DATA
    '===============================

    Protected Sub btnSearch_Click(
        sender As Object,
        e As EventArgs)

        LoadLeaveReport()

    End Sub


    Protected Sub btnReset_Click(
        sender As Object,
        e As EventArgs)

        ddlReportEmployee.SelectedIndex = 0
        ddlReportLeaveType.SelectedIndex = 0
        ddlReportStatus.SelectedIndex = 0

        txtReportFromDate.Text = ""
        txtReportToDate.Text = ""

        LoadLeaveReport()

    End Sub


    '===============================
    ' SAMPLE REPORT DATA
    '===============================

    Private Sub LoadLeaveReport()

        Dim dt As New DataTable()

        dt.Columns.Add("SrNo")
        dt.Columns.Add("EmployeeCode")
        dt.Columns.Add("EmployeeName")
        dt.Columns.Add("LeaveTypeName")
        dt.Columns.Add("FromDate")
        dt.Columns.Add("ToDate")
        dt.Columns.Add("TotalDays")
        dt.Columns.Add("Reason")
        dt.Columns.Add("Status")

        dt.Rows.Add(
            1,
            "EMP001",
            "Vijay Pandey",
            "Casual Leave (CL)",
            "20-Sep-2026",
            "21-Sep-2026",
            2,
            "Personal work",
            "Pending"
        )

        dt.Rows.Add(
            2,
            "EMP002",
            "Rahul Patil",
            "Sick Leave (SL)",
            "15-Sep-2026",
            "16-Sep-2026",
            2,
            "Not feeling well",
            "Approved"
        )

        dt.Rows.Add(
            3,
            "EMP003",
            "Priya Sharma",
            "Earned Leave (EL)",
            "10-Sep-2026",
            "12-Sep-2026",
            3,
            "Family function",
            "Rejected"
        )

        gvLeaveReport.DataSource = dt
        gvLeaveReport.DataBind()

    End Sub


    '===============================
    ' GRID PAGING
    '===============================

    Protected Sub gvLeaveReport_PageIndexChanging(
        sender As Object,
        e As GridViewPageEventArgs)

        gvLeaveReport.PageIndex = e.NewPageIndex

        LoadLeaveReport()

    End Sub


    '===============================
    ' STATUS CSS
    '===============================

    Public Function GetStatusClass(
        status As String) As String

        Select Case status.ToLower()

            Case "pending"
                Return "status-pending"

            Case "approved"
                Return "status-approved"

            Case "rejected"
                Return "status-rejected"

            Case Else
                Return ""

        End Select

    End Function

End Class