Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.ApplicationBlocks.Data
Namespace Trade_Application
    Public Module DataUtil

        Private ReadOnly ConStr As String =
        ConfigurationManager.ConnectionStrings("dms").ConnectionString

        Private Function GetConnection() As SqlConnection
            Return New SqlConnection(ConStr)
        End Function

        Public Function ExecuteNonQuery(
        ByVal spName As String,
        ByVal ParamArray values() As Object) As Integer

            Using con As SqlConnection = GetConnection()
                Using cmd As New SqlCommand(spName, con)

                    cmd.CommandType = CommandType.StoredProcedure
                    con.Open()

                    SqlCommandBuilder.DeriveParameters(cmd)

                    FillParams(cmd, values)

                    Return cmd.ExecuteNonQuery()

                End Using
            End Using

        End Function

        Public Function ExecuteScalar(
        ByVal spName As String,
        ByVal ParamArray values() As Object) As Object

            Using con As SqlConnection = GetConnection()
                Using cmd As New SqlCommand(spName, con)

                    cmd.CommandType = CommandType.StoredProcedure
                    con.Open()

                    SqlCommandBuilder.DeriveParameters(cmd)

                    FillParams(cmd, values)

                    Return cmd.ExecuteScalar()

                End Using
            End Using

        End Function

        Public Function ExecuteDataset(
        ByVal spName As String,
        ByVal ParamArray values() As Object) As DataSet

            Dim ds As New DataSet

            Using con As SqlConnection = GetConnection()
                Using cmd As New SqlCommand(spName, con)

                    cmd.CommandType = CommandType.StoredProcedure
                    con.Open()

                    SqlCommandBuilder.DeriveParameters(cmd)

                    FillParams(cmd, values)

                    Using da As New SqlDataAdapter(cmd)
                        da.Fill(ds)
                    End Using

                End Using
            End Using

            Return ds

        End Function

        Public Function ExecuteSQLQuery(
        ByVal sql As String) As DataSet

            Dim ds As New DataSet

            Using con As SqlConnection = GetConnection()
                Using da As New SqlDataAdapter(sql, con)
                    da.Fill(ds)
                End Using
            End Using

            Return ds

        End Function
        Public Function ExecuteSQLQuery(ByRef cn As SqlConnection, ByRef trans As SqlTransaction, ByVal SQLQuery As String) As DataSet
            Dim ds As New DataSet()

            Try
                Dim da As New SqlDataAdapter
                Dim sqlCommand As New SqlCommand(SQLQuery, cn, trans)
                da.SelectCommand = sqlCommand
                da.Fill(ds)
            Catch ex As Exception
                Throw ex
            Finally
            End Try
            Return ds
        End Function
        Public Function ExecuteScalar(ByVal trans As SqlTransaction, ByVal Query As String) As Object
            Return SqlHelper.ExecuteScalar(trans, CommandType.Text, Query)
        End Function
        Private Sub FillParams(
        ByVal cmd As SqlCommand,
        ByVal values() As Object)

            For i As Integer = 1 To cmd.Parameters.Count - 1

                If i <= values.Length Then

                    If values(i - 1) Is Nothing Then
                        cmd.Parameters(i).Value = DBNull.Value
                    Else
                        cmd.Parameters(i).Value = values(i - 1)
                    End If

                End If

            Next

        End Sub
        Public Function ExecuteNonQuery(ByVal trans As SqlTransaction, ByVal storedProcedureName As String, ByVal ParamArray parameters As Object()) As Integer
            Return SqlHelper.ExecuteNonQuery(trans, storedProcedureName, parameters)
        End Function
        Public Function ExecuteScalar(ByVal Query As String) As Object
            Return SqlHelper.ExecuteScalar(ConStr, CommandType.Text, Query)
        End Function
    End Module

End Namespace