<%@ Page Title=""
    Language="vb"
    AutoEventWireup="false"
    MasterPageFile="~/Site1.Master"
    CodeBehind="CommonMaster.aspx.vb"
    Inherits="VetanOne.CommonMaster" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <!-- BOOTSTRAP -->
    <link href="Css/5.3.3bootstrap.min.css"
        rel="stylesheet" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


    <style>
        .erp-card {
            border: none;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 10px 35px rgba(0,0,0,0.08);
        }

        .erp-header {
            background: linear-gradient(135deg,#0f4c81,#2563eb);
            padding: 18px 20px;
            color: white;
        }

        .erp-title {
            font-size: 20px;
            font-weight: 600;
        }

        .nav-pills .nav-link {
            border-radius: 12px;
            margin-right: 10px;
            color: #0f4c81;
            font-weight: 500;
        }

            .nav-pills .nav-link.active {
                background: linear-gradient(135deg,#0f4c81,#2563eb);
            }

        .form-control,
        .form-select {
            height: 46px;
            border-radius: 12px;
        }

        .btn-save {
            height: 46px;
            border-radius: 12px;
            background: linear-gradient(135deg,#0f4c81,#2563eb);
            border: none;
            color: white;
            font-weight: 600;
        }



        /* GRID */

        .erp-grid {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            overflow: hidden;
            border-radius: 16px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

            .erp-grid th {
                background: linear-gradient(135deg,#0f4c81,#2563eb);
                color: white;
                padding: 14px;
                font-size: 14px;
                font-weight: 600;
                border: none;
            }

            .erp-grid td {
                padding: 12px;
                background: white;
                border-bottom: 1px solid #e2e8f0;
            }

            .erp-grid tr:hover td {
                background: #f8fafc;
            }

        .grid-action {
            border: none;
            padding: 6px 12px;
            border-radius: 8px;
            color: white;
            font-size: 13px;
        }

        .btn-edit {
            background: #2563eb;
        }

        .btn-delete {
            background: #dc2626;
        }
    </style>

    <script type="text/javascript">

        document.addEventListener("DOMContentLoaded", function () {

            // Restore Active Tab
            var activeTab = sessionStorage.getItem("ActiveTab");

            if (activeTab) {

                var trigger = document.querySelector(
                    '[data-bs-target="' + activeTab + '"]');

                if (trigger) {

                    bootstrap.Tab.getOrCreateInstance(trigger).show();

                }
            }

            // Save Active Tab
            var tabs = document.querySelectorAll('[data-bs-toggle="pill"]');

            tabs.forEach(function (tab) {

                tab.addEventListener('shown.bs.tab', function (e) {

                    sessionStorage.setItem(
                        "ActiveTab",
                        e.target.getAttribute("data-bs-target"));

                });

            });

        });

    </script>

    <div class="card erp-card mt-3">

        <div class="erp-header">

            <div class="erp-title">
                🗂️ Common Master

            </div>

        </div>



        <div class="card-body">



            <!-- TAB HEADER -->

            <ul class="nav nav-pills mb-4"
                role="tablist">

                <li class="nav-item">

                    <button class="nav-link active"
                        data-bs-toggle="pill"
                        data-bs-target="#department"
                        type="button">
                        👥 Department

                    </button>

                </li>


                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#designation"
                        type="button">
                        🎖️ Designation

                    </button>

                </li>


                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#country"
                        type="button">
                        🌐 Country

                    </button>

                </li>
                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#state"
                        type="button">
                        📍 State

                    </button>

                </li>
                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#bank"
                        type="button">
                        🏦 Bank

                    </button>

                </li>


                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#pf"
                        type="button">
                        🔗 PF

                    </button>

                </li>


                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#esic"
                        type="button">
                        🔗 ESIC

                    </button>

                </li>
                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#pt"
                        type="button">
                        🔗 PT

                    </button>

                </li>
                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#lwf"
                        type="button">
                        🔗 LWF

                    </button>

                </li>
                <li class="nav-item">

                    <button class="nav-link"
                        data-bs-toggle="pill"
                        data-bs-target="#branch"
                        type="button">
                        🔗 Branch

                    </button>

                </li>

            </ul>




            <!-- TAB CONTENT -->

            <div class="tab-content">



                <!-- CLASS MASTER -->

                <div class="tab-pane fade show active"
                    id="department">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Class Name
                            </label>

                            <asp:TextBox ID="txtclassname"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>


                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnclasssave"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <!-- GRID -->

                    <div class="mt-4">

                        <asp:GridView ID="gvclass"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="SrNo"
                                    HeaderText="ClassId" />
                                <asp:BoundField DataField="Class"
                                    HeaderText="Class Name" />
                            </Columns>

                        </asp:GridView>

                    </div>

                </div>




                <!-- SUBJECT MASTER -->

                <div class="tab-pane fade"
                    id="subjectmaster">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Subject Name
                            </label>

                            <asp:TextBox ID="txtsubjectname"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>
                        <div class="col-md-1">

                            <label>
                                Marks
                            </label>

                            <asp:TextBox ID="txtmarks"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>
                        <div class="col-md-1">

                            <label>
                                Pass Marks
                            </label>

                            <asp:TextBox ID="txtpassmarks"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>

                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnsubjectsave"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <div class="mt-4">

                        <asp:GridView ID="gvsubject"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="SubjectId" HeaderText="Subject Id" />
                                <asp:BoundField DataField="SubjectName"
                                    HeaderText="Subject Name" />
                                <asp:BoundField DataField="Marks"
                                    HeaderText="Marks" />
                                <asp:BoundField DataField="PassMarks"
                                    HeaderText="PassMarks" />

                            </Columns>

                        </asp:GridView>

                    </div>

                </div>




                <!-- ACADEMIC YEAR -->

                <div class="tab-pane fade"
                    id="academicyear">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Academic Year
                            </label>

                            <asp:TextBox ID="txtacademicyear"
                                runat="server"
                                CssClass="form-control"
                                placeholder="2026-2027">
                            </asp:TextBox>

                        </div>


                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnyearsave"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <div class="mt-4">

                        <asp:GridView ID="gvyear"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="AcademicId"
                                    HeaderText="AcademicId" />
                                <asp:BoundField DataField="AcademicYear"
                                    HeaderText="Academic Year" />

                                <asp:BoundField DataField="StartDate"
                                    HeaderText="StartDate" />
                                <asp:BoundField DataField="EndDate"
                                    HeaderText="EndDate" />
                            </Columns>

                        </asp:GridView>

                    </div>

                </div>




                <!-- EXAM TYPE -->

                <div class="tab-pane fade"
                    id="examtype">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Exam Type
                            </label>

                            <asp:TextBox ID="txtexamtype"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>


                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnexamsave"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <div class="mt-4">

                        <asp:GridView ID="gvexam"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="SrNo"
                                    HeaderText="SrNo" />
                                <asp:BoundField DataField="ExamName"
                                    HeaderText="Exam Type" />


                            </Columns>

                        </asp:GridView>

                    </div>

                </div>




                <!-- HOLIDAY MASTER -->

                <div class="tab-pane fade"
                    id="holidaymaster">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Holiday Name
                            </label>

                            <asp:TextBox ID="txtholidayname"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>


                        <div class="col-md-3">

                            <label>
                                Holiday Date
                            </label>

                            <asp:TextBox ID="txtholidaydate"
                                runat="server"
                                TextMode="Date"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>


                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnholidaysave"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <div class="mt-4">

                        <asp:GridView ID="gvholiday"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="SrNo"
                                    HeaderText="SrNo" />
                                <asp:BoundField DataField="HolidayName"
                                    HeaderText="Holiday Name" />

                                <asp:BoundField DataField="HolidayDate"
                                    HeaderText="Holiday Date" />


                            </Columns>

                        </asp:GridView>

                    </div>

                </div>




                <!-- CLASS SUBJECT LINK -->

                <div class="tab-pane fade"
                    id="classsub">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Class
                            </label>

                            <asp:DropDownList ID="ddlclass"
                                runat="server"
                                CssClass="form-select">
                            </asp:DropDownList>

                        </div>


                        <div class="col-md-4">

                            <label>
                                Subject
                            </label>

                            <asp:DropDownList ID="ddlsubject"
                                runat="server"
                                CssClass="form-select">
                            </asp:DropDownList>

                        </div>


                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnsclink"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <div class="mt-4">

                        <asp:GridView ID="gvclasssubject"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="SrNo"
                                    HeaderText="SrNo" />
                                <asp:BoundField DataField="ClassName"
                                    HeaderText="Class Name" />

                                <asp:BoundField DataField="SubjectName"
                                    HeaderText="Subject Name" />



                            </Columns>

                        </asp:GridView>

                    </div>

                </div>

                <div class="tab-pane fade"
                    id="feetype">

                    <div class="row">

                        <div class="col-md-4">

                            <label>
                                Fee Type
                            </label>

                            <asp:TextBox ID="txtfeetype"
                                runat="server"
                                CssClass="form-control">
                            </asp:TextBox>

                        </div>


                        <div class="col-md-2 d-flex align-items-end">

                            <asp:Button ID="btnfeetype"
                                runat="server"
                                Text="SAVE"
                                CssClass="btn btn-save w-100" />

                        </div>

                    </div>



                    <div class="mt-4">

                        <asp:GridView ID="gvfeetype"
                            runat="server"
                            AutoGenerateColumns="False"
                            CssClass="table erp-grid">

                            <Columns>
                                <asp:BoundField DataField="Srno"
                                    HeaderText="SrNo" />
                                <asp:BoundField DataField="FeeName"
                                    HeaderText="Fee Type" />



                            </Columns>

                        </asp:GridView>

                    </div>

                </div>
            </div>

        </div>

    </div>

</asp:Content>
