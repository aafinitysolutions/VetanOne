Public Class Dashboard
    Inherits System.Web.UI.Page

    ' Time-of-day greeting; used in Dashboard.aspx as <%: Greeting %>
    Protected ReadOnly Property Greeting As String
        Get
            Dim h As Integer = DateTime.Now.Hour
            Dim part As String = If(h < 12, "Good morning", If(h < 17, "Good afternoon", "Good evening"))
            Dim name As String = If(Session("UserName") IsNot Nothing, Session("UserName").ToString().Trim(), "")
            Return If(name = "", part, part & ", " & name)
        End Get
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        ' TODO (backend): replace the hardcoded figures in Dashboard.aspx.
        ' The two chart datasets (TREND, MIX) sit at the top of the page script,
        ' so they can be emitted as JSON from here later.
    End Sub

End Class
