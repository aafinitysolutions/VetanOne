Imports System.Data
Imports System.Data.SqlClient

Public Class Login
    Inherits System.Web.UI.Page

    Private Const LoginCookie As String = "v1_login"
    Private Const CompanyCookie As String = "v1_company"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If IsPostBack Then Return

        If AppSession.UserId > 0 Then
            Response.Redirect("~/Dashboard.aspx", False)
            Return
        End If

        Try
            BindCompanies()
        Catch ex As Exception
            ShowError("Cannot reach the database. " & Db.FriendlyMessage(ex))
            Return
        End Try

        ' "Remember me" pre-fill (only the user id and company are remembered, never the password)
        Dim c = Request.Cookies(LoginCookie)
        If c IsNot Nothing AndAlso Not String.IsNullOrEmpty(c.Value) Then
            txtUserId.Text = c.Value
            chkRemember.Checked = True
            Dim cc = Request.Cookies(CompanyCookie)
            If cc IsNot Nothing AndAlso ddlCompany.Items.FindByValue(cc.Value) IsNot Nothing Then
                ddlCompany.ClearSelection()
                ddlCompany.Items.FindByValue(cc.Value).Selected = True
            End If
        ElseIf ddlCompany.Items.Count = 2 Then
            ddlCompany.SelectedIndex = 1          ' only one company: pick it for the user
        End If
    End Sub

    Private Sub BindCompanies()
        Dim dt = Db.Table("usp_Company_List")
        ddlCompany.Items.Clear()
        ddlCompany.Items.Add(New ListItem("Select company", ""))
        For Each r As DataRow In dt.Rows
            ddlCompany.Items.Add(New ListItem(r("CompanyName").ToString(), r("CompanyId").ToString()))
        Next
    End Sub

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        If Not Page.IsValid Then Return

        Dim companyId As Integer
        If Not Integer.TryParse(ddlCompany.SelectedValue, companyId) Then
            ShowError("Select your company.")
            Return
        End If

        Try
            Dim dt = Db.Table("usp_User_GetAuthInfo",
                              Db.P("@CompanyId", companyId),
                              Db.P("@LoginId", txtUserId.Text.Trim()))

            ' same message for "no such user" and "wrong password" so nobody can probe user ids
            If dt.Rows.Count = 0 OrElse
               Not PasswordHelper.Verify(dt.Rows(0)("PasswordSalt").ToString(), txtPassword.Text, DirectCast(dt.Rows(0)("PasswordHash"), Byte())) Then
                ShowError("The company, user ID or password is incorrect.")
                Return
            End If

            Dim r = dt.Rows(0)

            Session.Clear()
            Session("UserId") = CInt(r("UserId"))
            Session("CompanyId") = CInt(r("CompanyId"))
            Session("EmployeeId") = CInt(r("EmployeeId"))
            Session("Role") = r("UserRole").ToString()
            Session("UserName") = r("DisplayName").ToString()      ' read by Site1.master
            Session("EmailId") = r("LoginId").ToString()           ' read by Site1.master
            Session("ImagePath") = If(IsDBNull(r("PhotoPath")), "", r("PhotoPath").ToString())

            Db.NonQuery("usp_User_TouchLogin", Db.P("@UserId", CInt(r("UserId"))))

            SetRememberCookies(companyId)
            Response.Redirect("~/Dashboard.aspx", False)
            Context.ApplicationInstance.CompleteRequest()

        Catch ex As SqlException
            ShowError("Cannot sign in right now. " & Db.FriendlyMessage(ex))
        End Try
    End Sub

    Private Sub SetRememberCookies(companyId As Integer)
        If chkRemember.Checked Then
            Dim a As New HttpCookie(LoginCookie, txtUserId.Text.Trim()) With {.Expires = DateTime.Now.AddDays(30), .HttpOnly = True}
            Dim b As New HttpCookie(CompanyCookie, companyId.ToString()) With {.Expires = DateTime.Now.AddDays(30), .HttpOnly = True}
            Response.Cookies.Add(a)
            Response.Cookies.Add(b)
        Else
            Response.Cookies.Add(New HttpCookie(LoginCookie) With {.Expires = DateTime.Now.AddDays(-1)})
            Response.Cookies.Add(New HttpCookie(CompanyCookie) With {.Expires = DateTime.Now.AddDays(-1)})
        End If
    End Sub

    Private Sub ShowError(message As String)
        lblMessage.Text = Server.HtmlEncode(message)
        lblMessage.Visible = True
    End Sub

End Class
