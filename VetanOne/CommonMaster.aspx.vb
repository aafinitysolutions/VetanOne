Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Net.Mail
Imports AjaxControlToolkit.HTMLEditor.ToolbarButton
Imports VetanOne.Trade_Application
Public Class CommonMaster
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            FillClass()
            FillSubject()
            FillAcademicYear()
            FillExamType()
            FillHolidays()
            FillClassSubject()
            FillFeemaster()
        End If
    End Sub

    Private Sub btnclasssave_Click(sender As Object, e As EventArgs) Handles btnclasssave.Click
        Try


            If txtclassname.Text = "" Then
                Showmsg("Enter Class Name", "warning")
                Exit Sub
            End If
            Dim count As Integer = DataUtil.ExecuteScalar("select count(*) from Classmaster where class='" & txtclassname.Text & "'")
            If count > 0 Then
                Showmsg("Duplicate", "warning")
                Exit Sub
            End If
            DataUtil.ExecuteSQLQuery("insert into ClassMaster values('" & txtclassname.Text & "')")
            FillClass()
            Showmsg("Saved", "success")
        Catch ex As Exception
            Showmsg(ex.Message, "error")
        End Try
    End Sub
    Private Sub FillClass()
        Dim ds As DataSet = DataUtil.ExecuteSQLQuery("select  *from ClassMaster")
        gvclass.DataSource = ds.Tables(0)
        gvclass.DataBind()

        ddlclass.Items.Clear()
        ddlclass.AppendDataBoundItems = True
        ddlclass.Items.Add("Select Class")
        ddlclass.Items(0).Value = "0"
        ddlclass.DataSource = ds.Tables(0)
        ddlclass.DataValueField = "class"
        ddlclass.DataTextField = "class"
        ddlclass.DataBind()


    End Sub
    Private Sub Showmsg(ByVal msgtext As String,
                      ByVal msgtype As String)

        Dim msgicon As String = "info"

        Select Case msgtype.ToUpper()

            Case "SUCCESS"
                msgicon = "success"

            Case "ERROR"
                msgicon = "error"

            Case "WARNING"
                msgicon = "warning"

            Case "INFO"
                msgicon = "info"

            Case "EXCEPTION"
                msgicon = "error"

        End Select


        Dim script As String =
        "Swal.fire({

            title: '" & msgtype & "',
            text: '" & msgtext & "',
            icon: '" & msgicon & "',

            customClass: {
                popup: 'custom-popup',
                title: 'custom-title'
            },

            confirmButtonText: 'OK'

        });"

        ClientScript.RegisterStartupScript(Me.GetType(),
                                           Guid.NewGuid().ToString(),
                                           script,
                                           True)

    End Sub

    Private Sub btnsubjectsave_Click(sender As Object, e As EventArgs) Handles btnsubjectsave.Click
        Try
            If txtsubjectname.Text = "" Then
                Showmsg("Enter Subject Name", "warning")
                Exit Sub
            End If
            If Val(txtmarks.Text) = 0 Then
                Showmsg("Enter Marks", "warning")
                Exit Sub
            End If
            If Val(txtpassmarks.Text) = 0 Then
                Showmsg("Enter Passing Marks", "warning")
                Exit Sub
            End If
            Dim scount As Integer = DataUtil.ExecuteScalar("select count(*) from SubjectMaster where subjectName='" & txtsubjectname.Text & "'")
            If scount > 0 Then
                Showmsg("Duplicate not allowed", "warning")
                Exit Sub
            End If
            DataUtil.ExecuteSQLQuery("insert into SubjectMaster values('" & txtsubjectname.Text & "'," & Val(txtmarks.Text) & "," & Val(txtpassmarks.Text) & ")")
            Showmsg("Save Succesfully", "success")
            FillSubject()
        Catch ex As Exception
            Showmsg(ex.Message, "error")
        End Try
    End Sub
    Private Sub FillSubject()
        Try
            Dim ds As DataSet = DataUtil.ExecuteSQLQuery("SELECT SrNo AS SubjectId,SubjectName,Marks,PassMarks  FROM SubjectMaster ")
            gvsubject.DataSource = ds.Tables(0)
            gvsubject.DataBind()

            ddlsubject.Items.Clear()
            ddlsubject.AppendDataBoundItems = True
            ddlsubject.Items.Add("Select Subject")
            ddlsubject.Items(0).Value = "0"
            ddlsubject.DataSource = ds.Tables(0)
            ddlsubject.DataValueField = "SubjectName"
            ddlsubject.DataTextField = "SubjectName"
            ddlsubject.DataBind()
        Catch ex As Exception
            Showmsg(ex.Message, "Error")
        End Try
    End Sub

    Private Sub btnyearsave_Click(sender As Object, e As EventArgs) Handles btnyearsave.Click
        Try
            If txtacademicyear.Text = "" Then
                Showmsg("Enter Academic Year", "warning")
                Exit Sub
            End If
            Dim cnt As Integer = DataUtil.ExecuteScalar("SELECT count(*) FROM AcademicYear WHERE AcaYear ='" & txtacademicyear.Text & "'")
            If cnt > 0 Then
                Showmsg("Duplicate", "Warning")
                Exit Sub
            End If
            Dim startdate As String = "01-Apr-" & Left(txtacademicyear.Text, 4)
            Dim enddate As String = "31-Mar-" & Right(txtacademicyear.Text, 4)
            DataUtil.ExecuteSQLQuery("insert into AcademicYear values('" & txtacademicyear.Text & "','" & startdate & "','" & enddate & "')")
            Showmsg("Save Succesfully", "success")
            FillAcademicYear()
        Catch ex As Exception
            Showmsg(ex.Message, "Error")
        End Try
    End Sub
    Private Sub FillAcademicYear()
        Try
            Dim ds As DataSet = DataUtil.ExecuteSQLQuery("SELECT Aid AS AcademicId,AcaYear AS AcademicYear,format(StartDate,'dd-MMM-yyyy') AS StartDate,format(EndDate,'dd-MMM-yyyy') AS EndDate FROM AcademicYear  ")
            gvyear.DataSource = ds.Tables(0)
            gvyear.DataBind()
        Catch ex As Exception
            Showmsg(ex.Message, "Error")
        End Try
    End Sub

    Private Sub btnexamsave_Click(sender As Object, e As EventArgs) Handles btnexamsave.Click
        Try
            If txtexamtype.Text = "" Then
                Showmsg("Enter Exam Type", "warning")
                Exit Sub
            End If
            Dim cnt As Integer = DataUtil.ExecuteScalar("SELECT count(*) FROM ExamType WHERE ExamName  ='" & txtexamtype.Text & "'")
            If cnt > 0 Then
                Showmsg("Duplicate", "Warning")
                Exit Sub
            End If
            DataUtil.ExecuteSQLQuery("insert into ExamType values('" & txtexamtype.Text & "')")
            Showmsg("Save Succesfully", "success")
            FillExamType()
        Catch ex As Exception

        End Try
    End Sub
    Private Sub FillExamType()
        Try
            Dim ds As DataSet = DataUtil.ExecuteSQLQuery("SELECT SrNo AS SrNo,ExamName FROM ExamType")
            gvexam.DataSource = ds.Tables(0)
            gvexam.DataBind()
        Catch ex As Exception
            Showmsg(ex.Message, "error")
        End Try
    End Sub

    Private Sub btnholidaysave_Click(sender As Object, e As EventArgs) Handles btnholidaysave.Click
        Try
            If txtholidayname.Text = "" Then
                Showmsg("Enter Holiday Name", "warning")
                Exit Sub
            End If
            If txtholidaydate.Text = "" Then
                Showmsg("Enter Holiday Date", "warning")
                Exit Sub
            End If
            Dim cnt As Integer = DataUtil.ExecuteScalar("select count(*) from HoliDays where HolidayName='" & txtholidayname.Text & "' and HDate='" & CDate(txtholidaydate.Text).ToString("dd-MMM-yyyy") & "'")
            If cnt > 0 Then
                Showmsg("Duplicate", "Warning")
                Exit Sub
            End If
            If Session("AcdYear") = Nothing Then
                Response.Redirect("Login.aspx")
                Exit Sub
            Else
                DataUtil.ExecuteSQLQuery("insert into HoliDays values('" & txtholidayname.Text & "','" & CDate(txtholidaydate.Text).ToString("dd-MMM-yyyy") & "','" & Session("AcdYear") & "')")
                Showmsg("Save Succesfully", "success")
                FillHolidays()
            End If
        Catch ex As Exception
            Showmsg(ex.Message, "erroor")
        End Try
    End Sub
    Private Sub FillHolidays()
        Dim ds As DataSet = DataUtil.ExecuteSQLQuery(" SELECT SrNo,HolidayName,format(HDate,'dd-MMM-yyyy') AS HolidayDate  FROM HoliDays WHERE AcadYear='" & Session("AcdYear") & "'")
        gvholiday.DataSource = ds.Tables(0)
        gvholiday.DataBind()
    End Sub

    Private Sub btnsclink_Click(sender As Object, e As EventArgs) Handles btnsclink.Click
        Try
            If ddlclass.SelectedIndex = 0 Then
                Showmsg("Select Class", "Warning")
                Exit Sub
            End If
            If ddlsubject.SelectedIndex = 0 Then
                Showmsg("Select Subject", "Warning")
                Exit Sub
            End If
            Dim cnt As Integer = DataUtil.ExecuteScalar("select * from ClassSubject where ClassName='" & ddlclass.SelectedValue & "' And SubjectName ='" & ddlsubject.SelectedValue & "'")
            If cnt > 0 Then
                Showmsg("Duplicate", "Warning")
                Exit Sub
            End If
            DataUtil.ExecuteSQLQuery("insert into ClassSubject values('" & ddlclass.SelectedValue & "','" & ddlsubject.SelectedValue & "') ")
            Showmsg("Save Succesfully", "success")
            FillClassSubject()
        Catch ex As Exception
            Showmsg(ex.Message, "error")
        End Try
    End Sub
    Private Sub FillClassSubject()
        Dim ds As DataSet = DataUtil.ExecuteSQLQuery("SELECT SrNo ,ClassName,SubjectName FROM ClassSubject  ")
        gvclasssubject.DataSource = ds.Tables(0)
        gvclasssubject.DataBind()
    End Sub

    Private Sub btnfeetype_Click(sender As Object, e As EventArgs) Handles btnfeetype.Click
        Try
            If txtfeetype.Text = "" Then
                Showmsg("Enter Exam Type", "warning")
                Exit Sub
            End If
            Dim cnt As Integer = DataUtil.ExecuteScalar("SELECT count(*) FROM FeeType WHERE FeeName  ='" & txtfeetype.Text & "'")
            If cnt > 0 Then
                Showmsg("Duplicate", "Warning")
                Exit Sub
            End If
            DataUtil.ExecuteSQLQuery("insert into FeeType values('" & txtfeetype.Text & "') ")
            Showmsg("Save Succesfully", "success")
            FillFeemaster()
        Catch ex As Exception
            Showmsg(ex.Message, "error")
        End Try
    End Sub
    Private Sub FillFeemaster()
        Dim ds As DataSet = DataUtil.ExecuteSQLQuery("select *from FeeType ")
        gvfeetype.DataSource = ds.Tables(0)
        gvfeetype.DataBind()
    End Sub
End Class