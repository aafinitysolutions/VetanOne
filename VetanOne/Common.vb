Imports System
Imports System.Data.SqlClient
Imports System.Data
Imports System.DateTime
Imports System.Globalization
Imports System.Collections.Generic
Imports System.Text
Imports System.Net
Imports System.IO
Imports System.ComponentModel
Imports Microsoft.CSharp
Imports System.Reflection
Imports Microsoft.VisualBasic.VBMath
Imports Microsoft.VisualBasic.Strings
Imports VetanOne.Trade_Application


Public Module Common
    Public Function GetLineNumber(ByVal ex As Exception) As String
        Dim lineNumber As Integer = 0
        Dim result As String
        Const lineSearch As String = ":line "
        Dim index = ex.StackTrace.LastIndexOf(lineSearch)
        If index <> -1 Then
            Dim lineNumberText = ex.StackTrace.Substring(index + lineSearch.Length)
            If Int32.TryParse(lineNumberText, lineNumber) Then
            End If
        End If
        result = CStr(lineNumber)
        Return result
    End Function
    Public Function FindFinYearStartDate(ByVal currdate As DateTime) As Date
        FindFinYearStartDate = Nothing
        If currdate.Month = 1 Or currdate.Month = 2 Or currdate.Month = 3 Then
            FindFinYearStartDate = New DateTime(currdate.Year - 1, 4, 1)
        Else
            FindFinYearStartDate = New DateTime(currdate.Year, 4, 1)
        End If
        Return FindFinYearStartDate
    End Function
    Public Function FindFinYearEndDate(ByVal currdate As DateTime) As Date
        FindFinYearEndDate = Nothing
        If currdate.Month = 1 Or currdate.Month = 2 Or currdate.Month = 3 Then
            FindFinYearEndDate = New DateTime(currdate.Year, 3, 31, 23, 59, 59)
        Else
            FindFinYearEndDate = New DateTime(currdate.Year + 1, 4, 1, 23, 59, 59)
        End If
        Return FindFinYearEndDate
    End Function
    Public Function FindAcadeMicYearStrtEndDate(ByVal Acdyear As String) As DataTable
        Dim ds As DataSet = DataUtil.ExecuteSQLQuery("select * from AcademicYear where AcaYear='" & Acdyear & "'")
        Return ds.Tables(0)
    End Function
    Public Function ExtractFinYearShort(ByVal finyear As String) As String
        Dim finshortyear As String = Mid(finyear, 3, 2) & Right(finyear, 2)
        Return finshortyear
    End Function
End Module
