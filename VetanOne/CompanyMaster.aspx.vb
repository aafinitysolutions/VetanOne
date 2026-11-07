Public Class CompanyMaster
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Function GetLogoUrl(value As Object) As String
        Dim path = Convert.ToString(value)
        If String.IsNullOrWhiteSpace(path) Then Return ResolveUrl("~/Images/no-photo.png")
        Return ResolveUrl(path)
    End Function
End Class