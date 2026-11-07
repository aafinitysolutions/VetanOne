Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Security.Cryptography
Imports System.Text
Imports System.Web
Imports System.Web.SessionState
Imports System.Web.UI

' Add this file to your project (e.g. in a DataAccess folder). No Namespace block on purpose:
' with the project's root namespace VetanOne these classes are VetanOne.Db, VetanOne.AppSession, etc.

''' <summary>Thin ADO.NET helper: every call runs one stored procedure.</summary>
Public NotInheritable Class Db

    Private Sub New()
    End Sub

    Private Shared Function ConnStr() As String
        Dim cs = ConfigurationManager.ConnectionStrings("VetanOneDb")
        If cs Is Nothing Then Throw New ConfigurationErrorsException("Connection string 'VetanOneDb' is missing from Web.config.")
        Return cs.ConnectionString
    End Function

    ' ---- parameter helpers ------------------------------------------------

    ''' <summary>Input parameter; Nothing becomes SQL NULL.</summary>
    Public Shared Function P(name As String, value As Object) As SqlParameter
        Return New SqlParameter(name, If(value, DBNull.Value))
    End Function

    ''' <summary>Blank / whitespace text becomes NULL; otherwise trimmed and cut to maxLen.</summary>
    Public Shared Function Txt(value As String, Optional maxLen As Integer = 0) As Object
        If String.IsNullOrWhiteSpace(value) Then Return Nothing
        Dim s = value.Trim()
        If maxLen > 0 AndAlso s.Length > maxLen Then s = s.Substring(0, maxLen)
        Return s
    End Function

    ''' <summary>"" or "0" becomes NULL; otherwise the integer.</summary>
    Public Shared Function IntOrNull(value As String) As Object
        Dim n As Integer
        If Integer.TryParse(value, n) AndAlso n > 0 Then Return n
        Return Nothing
    End Function

    Public Shared Function IdOrNull(value As Integer) As Object
        If value > 0 Then Return value
        Return Nothing
    End Function

    Public Shared Function OutInt(name As String) As SqlParameter
        Return New SqlParameter(name, SqlDbType.Int) With {.Direction = ParameterDirection.Output}
    End Function

    Public Shared Function InOutInt(name As String, value As Integer) As SqlParameter
        Return New SqlParameter(name, SqlDbType.Int) With {.Direction = ParameterDirection.InputOutput, .Value = value}
    End Function

    ' ---- execution --------------------------------------------------------

    Private Shared Function NewCommand(con As SqlConnection, proc As String, prms() As SqlParameter) As SqlCommand
        Dim cmd As New SqlCommand(proc, con) With {.CommandType = CommandType.StoredProcedure, .CommandTimeout = 30}
        If prms IsNot Nothing Then cmd.Parameters.AddRange(prms)
        Return cmd
    End Function

    Public Shared Function Table(proc As String, ParamArray prms() As SqlParameter) As DataTable
        Using con As New SqlConnection(ConnStr())
            Using cmd As SqlCommand = NewCommand(con, proc, prms)
                Using da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    Return dt
                End Using
            End Using
        End Using
    End Function

    Public Shared Function Sets(proc As String, ParamArray prms() As SqlParameter) As DataSet
        Using con As New SqlConnection(ConnStr())
            Using cmd As SqlCommand = NewCommand(con, proc, prms)
                Using da As New SqlDataAdapter(cmd)
                    Dim ds As New DataSet()
                    da.Fill(ds)
                    Return ds
                End Using
            End Using
        End Using
    End Function

    Public Shared Function Scalar(proc As String, ParamArray prms() As SqlParameter) As Object
        Using con As New SqlConnection(ConnStr())
            Using cmd As SqlCommand = NewCommand(con, proc, prms)
                con.Open()
                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function

    Public Shared Sub NonQuery(proc As String, ParamArray prms() As SqlParameter)
        Using con As New SqlConnection(ConnStr())
            Using cmd As SqlCommand = NewCommand(con, proc, prms)
                con.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    ''' <summary>
    ''' Text safe to show the user. Business-rule errors (THROW 50000+) are shown as written;
    ''' anything else is generic, unless debug="true" in Web.config (then you get the real message).
    ''' </summary>
    Public Shared Function FriendlyMessage(ex As Exception) As String
        Dim sqlEx = TryCast(ex, SqlException)
        If sqlEx IsNot Nothing AndAlso sqlEx.Number >= 50000 Then Return sqlEx.Message
        System.Diagnostics.Trace.TraceError(ex.ToString())
        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.IsDebuggingEnabled Then Return ex.Message
        Return "Something went wrong while saving. Please try again."
    End Function

End Class


''' <summary>Typed access to the values Login.aspx puts in Session.</summary>
Public NotInheritable Class AppSession

    Private Sub New()
    End Sub

    Private Shared ReadOnly Property S As HttpSessionState
        Get
            Return HttpContext.Current.Session
        End Get
    End Property

    Private Shared Function GetInt(key As String) As Integer
        Dim o = S(key)
        Dim n As Integer
        If o IsNot Nothing AndAlso Integer.TryParse(o.ToString(), n) Then Return n
        Return 0
    End Function

    Public Shared ReadOnly Property UserId As Integer
        Get
            Return GetInt("UserId")
        End Get
    End Property

    Public Shared ReadOnly Property CompanyId As Integer
        Get
            Return GetInt("CompanyId")
        End Get
    End Property

    ''' <summary>0 when the login is not linked to an employee record.</summary>
    Public Shared ReadOnly Property EmployeeId As Integer
        Get
            Return GetInt("EmployeeId")
        End Get
    End Property

    Public Shared ReadOnly Property Role As String
        Get
            Dim o = S("Role")
            Return If(o Is Nothing, "", o.ToString())
        End Get
    End Property

    Public Shared ReadOnly Property IsAdminOrHr As Boolean
        Get
            Return Role = "Admin" OrElse Role = "HR"
        End Get
    End Property

    Public Shared Sub RequireLogin()
        If UserId = 0 Then HttpContext.Current.Response.Redirect("~/Login.aspx", True)
    End Sub

End Class


''' <summary>Salted SHA-256, identical to HASHBYTES('SHA2_256', salt + password) in SQL Server.</summary>
Public NotInheritable Class PasswordHelper

    Private Sub New()
    End Sub

    Public Shared Function Hash(salt As String, password As String) As Byte()
        Using sha As SHA256 = SHA256.Create()
            Return sha.ComputeHash(Encoding.Unicode.GetBytes(salt & password))   ' Unicode = UTF-16LE = NVARCHAR bytes
        End Using
    End Function

    Public Shared Function Verify(salt As String, password As String, expected As Byte()) As Boolean
        Dim actual = Hash(salt, password)
        If expected Is Nothing OrElse expected.Length <> actual.Length Then Return False
        Dim diff As Integer = 0
        For i As Integer = 0 To actual.Length - 1
            diff = diff Or (actual(i) Xor expected(i))       ' constant-time compare
        Next
        Return diff = 0
    End Function

End Class


''' <summary>SweetAlert toasts and dialogs fired from code-behind (falls back to alert() if Swal is missing).</summary>
Public NotInheritable Class UiHelper

    Private Sub New()
    End Sub

    Public Shared Sub Toast(page As Page, icon As String, message As String)
        Dim m = HttpUtility.JavaScriptStringEncode(message, True)
        Run(page, "if(window.Swal){Swal.fire({toast:true,position:'top-end',icon:'" & icon & "',title:" & m &
                  ",showConfirmButton:false,timer:3400,customClass:{popup:'custom-popup'}});}else{alert(" & m & ");}")
    End Sub

    Public Shared Sub ErrorBox(page As Page, title As String, message As String)
        Dim t = HttpUtility.JavaScriptStringEncode(title, True)
        Dim m = HttpUtility.JavaScriptStringEncode(message, True)
        Run(page, "if(window.Swal){Swal.fire({icon:'error',title:" & t & ",text:" & m & ",confirmButtonColor:'#1F5C4F'});}else{alert(" & m & ");}")
    End Sub

    Private Shared Sub Run(page As Page, js As String)
        page.ClientScript.RegisterStartupScript(page.GetType(), "ui" & Guid.NewGuid().ToString("N"),
            "document.addEventListener('DOMContentLoaded',function(){" & js & "});", True)
    End Sub

End Class


''' <summary>Saves uploads under ~/Uploads with a random name and a checked extension.</summary>
Public NotInheritable Class FileStore

    Private Sub New()
    End Sub

    ''' <summary>Returns the virtual path (e.g. ~/Uploads/Photos/ab12.jpg). Throws InvalidOperationException with a user-friendly message.</summary>
    Public Shared Function Save(file As HttpPostedFile, folder As String, allowedExt() As String, maxBytes As Integer) As String
        Dim ext = Path.GetExtension(file.FileName).ToLowerInvariant()
        If Array.IndexOf(allowedExt, ext) < 0 Then
            Throw New InvalidOperationException("That file type is not allowed. Use: " & String.Join(", ", allowedExt) & ".")
        End If
        If file.ContentLength <= 0 Then Throw New InvalidOperationException("The selected file is empty.")
        If file.ContentLength > maxBytes Then
            Throw New InvalidOperationException("The file is too large. Maximum size is " & (maxBytes \ (1024 * 1024)) & " MB.")
        End If

        Dim dir = HttpContext.Current.Server.MapPath(folder)
        Directory.CreateDirectory(dir)
        Dim name = Guid.NewGuid().ToString("N") & ext
        file.SaveAs(Path.Combine(dir, name))
        Return folder.TrimEnd("/"c) & "/" & name
    End Function

    Public Shared Sub DeleteQuietly(virtualPath As String)
        Try
            If String.IsNullOrEmpty(virtualPath) OrElse Not virtualPath.StartsWith("~/Uploads/", StringComparison.OrdinalIgnoreCase) Then Return
            Dim phys = HttpContext.Current.Server.MapPath(virtualPath)
            If File.Exists(phys) Then File.Delete(phys)
        Catch
            ' a leftover file is harmless
        End Try
    End Sub

End Class
