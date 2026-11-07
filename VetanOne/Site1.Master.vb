Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.EnterpriseServices
Imports System.Net.Mail
Imports AjaxControlToolkit.HTMLEditor.ToolbarButton
Imports VetanOne.Trade_Application
Public Class Site1
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            If Session("UserID") Is Nothing Then
                Response.Redirect("~/Login.aspx")
                Return
            End If

        End If
    End Sub

End Class