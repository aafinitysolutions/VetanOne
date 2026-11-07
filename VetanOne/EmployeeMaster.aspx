<%@ Page Title="Employee Master" Language="VB" MasterPageFile="~/Site1.master" AutoEventWireup="false" CodeBehind="EmployeeMaster.aspx.vb" Inherits="VetanOne.EmployeeMaster" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="page-container">

    <style>
        /* Safety net: the same rules live in theme-additions.css. They keep the tabs
           working even if that file has not been pasted into theme.css yet. */
        .tab-panel-v1 { display: none; }
        .tab-panel-v1.active { display: block; }
        .em-head { display: flex; align-items: center; justify-content: space-between; gap: 12px 20px; flex-wrap: wrap; margin-bottom: 14px; }
        .em-mode { font-family: var(--font-display, serif); font-size: 17px; font-weight: 500; }
        .em-find { display: flex; align-items: center; gap: 8px; }
        .em-find .form-control-v1 { width: 230px; }
    </style>

    <asp:HiddenField ID="hfEmployeeId" runat="server" Value="0" />
    <asp:HiddenField ID="hfTab" runat="server" Value="tabGeneral" />

    <div class="em-head">
        <asp:Label ID="lblMode" runat="server" CssClass="em-mode" Text="New employee" />
        <asp:Panel ID="pnlFind" runat="server" CssClass="em-find" DefaultButton="btnFind">
            <asp:TextBox ID="txtFind" runat="server" CssClass="form-control-v1" placeholder="Find by code or name" />
            <asp:LinkButton ID="btnFind" runat="server" CssClass="btn btn-v1-secondary" CausesValidation="false"
                OnClick="btnFind_Click"><i class="bi bi-search"></i> Find</asp:LinkButton>
            <a href="EmployeeMaster.aspx" class="btn btn-v1-ghost"><i class="bi bi-plus-lg"></i> New</a>
        </asp:Panel>
    </div>

    <!-- ===================== TABS ===================== -->
    <div class="tabs-v1 mb-v1-4">
        <button type="button" class="tab-v1 active" data-tab="tabGeneral"><i class="bi bi-person-vcard me-1"></i>General Information</button>
        <button type="button" class="tab-v1" data-tab="tabDocs"><i class="bi bi-paperclip me-1"></i>Attachments / Documents</button>
    </div>


    <!-- ===================== GENERAL INFORMATION ===================== -->
    <div id="tabGeneral" class="tab-panel-v1 active">

        <!-- ---------- Basic information ---------- -->
        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-person"></i>Basic information</h3>
            </div>

            <div class="row g-4">
                <div class="col-lg-9">
                    <div class="row g-3">

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtEmpCode.ClientID %>">Employee code<span class="required">*</span></label>
                            <asp:TextBox ID="txtEmpCode" runat="server" CssClass="form-control-v1" MaxLength="20" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmpCode" ValidationGroup="emp"
                                Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Employee code is required." />
                        </div>

                        <div class="col-md-8">
                            <label class="form-label-v1" for="<%= txtEmpName.ClientID %>">Employee name<span class="required">*</span></label>
                            <asp:TextBox ID="txtEmpName" runat="server" CssClass="form-control-v1" MaxLength="100" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmpName" ValidationGroup="emp"
                                Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Employee name is required." />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtFatherSpouse.ClientID %>">Father / Spouse</label>
                            <asp:TextBox ID="txtFatherSpouse" runat="server" CssClass="form-control-v1" MaxLength="100" />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtDOB.ClientID %>">Date of birth</label>
                            <asp:TextBox ID="txtDOB" runat="server" TextMode="Date" CssClass="form-control-v1" />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= ddlGender.ClientID %>">Gender<span class="required">*</span></label>
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-select-v1 select2-v1">
                                <asp:ListItem Text="Male" Value="M" />
                                <asp:ListItem Text="Female" Value="F" />
                                <asp:ListItem Text="Other" Value="O" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= ddlMarital.ClientID %>">Marital status</label>
                            <asp:DropDownList ID="ddlMarital" runat="server" CssClass="form-select-v1 select2-v1">
                                <asp:ListItem Text="Single" Value="S" />
                                <asp:ListItem Text="Married" Value="M" />
                                <asp:ListItem Text="Divorced" Value="D" />
                                <asp:ListItem Text="Widowed" Value="W" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= ddlBloodGroup.ClientID %>">Blood group</label>
                            <asp:DropDownList ID="ddlBloodGroup" runat="server" CssClass="form-select-v1 select2-v1">
                                <asp:ListItem Text="Select" Value="" />
                                <asp:ListItem Text="A+" Value="A+" />
                                <asp:ListItem Text="A-" Value="A-" />
                                <asp:ListItem Text="B+" Value="B+" />
                                <asp:ListItem Text="B-" Value="B-" />
                                <asp:ListItem Text="AB+" Value="AB+" />
                                <asp:ListItem Text="AB-" Value="AB-" />
                                <asp:ListItem Text="O+" Value="O+" />
                                <asp:ListItem Text="O-" Value="O-" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtMobile.ClientID %>">Mobile no.</label>
                            <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control-v1" MaxLength="10" inputmode="numeric" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtMobile" ValidationGroup="emp"
                                ValidationExpression="^[6-9][0-9]{9}$" Display="Dynamic" CssClass="field-error-v1"
                                ErrorMessage="Enter a valid 10-digit mobile number." />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtEmail.ClientID %>">Email ID</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control-v1" MaxLength="100" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail" ValidationGroup="emp"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" Display="Dynamic" CssClass="field-error-v1"
                                ErrorMessage="Enter a valid email address." />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtPAN.ClientID %>">PAN no.</label>
                            <asp:TextBox ID="txtPAN" runat="server" CssClass="form-control-v1 js-upper" MaxLength="10" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPAN" ValidationGroup="emp"
                                ValidationExpression="^[A-Z]{5}[0-9]{4}[A-Z]$" Display="Dynamic" CssClass="field-error-v1"
                                ErrorMessage="PAN format should be ABCDE1234F." />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtAadhaar.ClientID %>">Aadhaar no.</label>
                            <asp:TextBox ID="txtAadhaar" runat="server" CssClass="form-control-v1" MaxLength="12" inputmode="numeric" />
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAadhaar" ValidationGroup="emp"
                                ValidationExpression="^[0-9]{12}$" Display="Dynamic" CssClass="field-error-v1"
                                ErrorMessage="Aadhaar must be 12 digits." />
                        </div>

                        <div class="col-md-4">
                            <label class="form-label-v1" for="<%= txtUAN.ClientID %>">UAN no.</label>
                            <asp:TextBox ID="txtUAN" runat="server" CssClass="form-control-v1" MaxLength="12" inputmode="numeric" />
                        </div>

                    </div>
                </div>

                <!-- photograph -->
                <div class="col-lg-3">
                    <label class="form-label-v1">Photograph</label>
                    <label class="photo-box <%= PhotoBoxClass %>" id="photoBox" for="<%= fuPhoto.ClientID %>">
                        <i class="bi bi-camera"></i>
                        <span>Upload photo</span>
                        <small>JPG or PNG, up to 2 MB</small>
                        <img id="photoPreview" alt="Employee photo preview" <%= PhotoSrcAttr %> />
                    </label>
                    <asp:FileUpload ID="fuPhoto" runat="server" CssClass="d-none" accept="image/png,image/jpeg" />
                    <button type="button" class="btn-v1-ghost d-none mt-v1-2" id="btnPhotoClear"><i class="bi bi-x-lg"></i> Remove photo</button>
                </div>
            </div>
        </section>


        <!-- ---------- Employment details ---------- -->
        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-briefcase"></i>Employment details</h3>
            </div>

            <div class="row g-3">

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlCompany.ClientID %>">Company<span class="required">*</span></label>
                    <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCompany" InitialValue="" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Select a company." />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlBranch.ClientID %>">Branch / location</label>
                    <asp:DropDownList ID="ddlBranch" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlDepartment.ClientID %>">Department<span class="required">*</span></label>
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDepartment" InitialValue="" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Select a department." />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlDesignation.ClientID %>">Designation<span class="required">*</span></label>
                    <asp:DropDownList ID="ddlDesignation" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlDesignation" InitialValue="" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Select a designation." />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlEmpType.ClientID %>">Employee type</label>
                    <asp:DropDownList ID="ddlEmpType" runat="server" CssClass="form-select-v1 select2-v1">
                        <asp:ListItem Text="Permanent" Value="P" />
                        <asp:ListItem Text="Contract" Value="C" />
                        <asp:ListItem Text="Trainee" Value="T" />
                        <asp:ListItem Text="Casual / Daily wage" Value="D" />
                    </asp:DropDownList>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlReportingTo.ClientID %>">Reporting to</label>
                    <asp:DropDownList ID="ddlReportingTo" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtDOJ.ClientID %>">Date of joining<span class="required">*</span></label>
                    <asp:TextBox ID="txtDOJ" runat="server" TextMode="Date" CssClass="form-control-v1" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDOJ" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Date of joining is required." />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtConfirmDate.ClientID %>">Confirmation date<span class="required">*</span></label>
                    <asp:TextBox ID="txtConfirmDate" runat="server" TextMode="Date" CssClass="form-control-v1" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmDate" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Confirmation date is required." />
                </div>

            </div>
        </section>


        <!-- ---------- Address ---------- -->
        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-geo-alt"></i>Address details</h3>
                <label class="switch-v1">
                    <input type="checkbox" id="chkSameAddr" />
                    <span>Permanent address is same as present</span>
                </label>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label-v1" for="<%= txtPresentAddr.ClientID %>">Present address</label>
                    <asp:TextBox ID="txtPresentAddr" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control-v1" MaxLength="300" />
                </div>
                <div class="col-md-6">
                    <label class="form-label-v1" for="<%= txtPermanentAddr.ClientID %>">Permanent address</label>
                    <asp:TextBox ID="txtPermanentAddr" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control-v1" MaxLength="300" />
                </div>
            </div>
        </section>


        <!-- ---------- Statutory / other ---------- -->
        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-shield-check"></i>Other / statutory information</h3>
            </div>

            <div class="row g-3">

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlCountry.ClientID %>">Country</label>
                    <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlState.ClientID %>">State</label>
                    <asp:DropDownList ID="ddlState" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtLanguages.ClientID %>">Languages known</label>
                    <asp:TextBox ID="txtLanguages" runat="server" CssClass="form-control-v1" MaxLength="100" placeholder="e.g. Telugu, Hindi, English" />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlStatus.ClientID %>">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select-v1 select2-v1">
                        <asp:ListItem Text="Active" Value="A" />
                        <asp:ListItem Text="Inactive" Value="I" />
                    </asp:DropDownList>
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtCTC.ClientID %>">CTC (annual)</label>
                    <div class="input-affix-v1">
                        <span class="affix">&#8377;</span>
                        <asp:TextBox ID="txtCTC" runat="server" CssClass="form-control-v1" inputmode="decimal" MaxLength="12" />
                    </div>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCTC" ValidationGroup="emp"
                        ValidationExpression="^[0-9]+(\.[0-9]{1,2})?$" Display="Dynamic" CssClass="field-error-v1"
                        ErrorMessage="Enter a valid amount." />
                </div>

            </div>

            <div class="row g-3 mt-v1-2">
                <div class="col-sm-6 col-lg">
                    <div class="flag-tile"><span class="flag-name">PF applicable</span>
                        <asp:CheckBox ID="chkPF" runat="server" Checked="true" CssClass="switch-v1" ToolTip="PF applicable" /></div>
                </div>
                <div class="col-sm-6 col-lg">
                    <div class="flag-tile"><span class="flag-name">ESIC applicable</span>
                        <asp:CheckBox ID="chkESIC" runat="server" Checked="true" CssClass="switch-v1" ToolTip="ESIC applicable" /></div>
                </div>
                <div class="col-sm-6 col-lg">
                    <div class="flag-tile"><span class="flag-name">PT applicable</span>
                        <asp:CheckBox ID="chkPT" runat="server" Checked="true" CssClass="switch-v1" ToolTip="PT applicable" /></div>
                </div>
                <div class="col-sm-6 col-lg">
                    <div class="flag-tile"><span class="flag-name">LWF applicable</span>
                        <asp:CheckBox ID="chkLWF" runat="server" Checked="true" CssClass="switch-v1" ToolTip="LWF applicable" /></div>
                </div>
                <div class="col-sm-6 col-lg">
                    <div class="flag-tile"><span class="flag-name">OT applicable</span>
                        <asp:CheckBox ID="chkOT" runat="server" Checked="true" CssClass="switch-v1" ToolTip="OT applicable" /></div>
                </div>
            </div>
        </section>


        <!-- ---------- Bank ---------- -->
        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-bank"></i>Bank details</h3>
            </div>

            <div class="row g-3">

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= ddlBank.ClientID %>">Bank name<span class="required">*</span></label>
                    <asp:DropDownList ID="ddlBank" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select bank" Value="" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlBank" InitialValue="" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Select a bank." />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtBranch.ClientID %>">Branch</label>
                    <asp:TextBox ID="txtBranch" runat="server" CssClass="form-control-v1" MaxLength="100" />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtAccountNo.ClientID %>">Account no.<span class="required">*</span></label>
                    <asp:TextBox ID="txtAccountNo" runat="server" CssClass="form-control-v1" MaxLength="20" inputmode="numeric" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAccountNo" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="Account number is required." />
                </div>

                <div class="col-sm-6 col-lg-3">
                    <label class="form-label-v1" for="<%= txtIFSC.ClientID %>">IFSC code<span class="required">*</span></label>
                    <asp:TextBox ID="txtIFSC" runat="server" CssClass="form-control-v1 js-upper" MaxLength="11" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtIFSC" ValidationGroup="emp"
                        Display="Dynamic" CssClass="field-error-v1" ErrorMessage="IFSC code is required." />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtIFSC" ValidationGroup="emp"
                        ValidationExpression="^[A-Z]{4}0[A-Z0-9]{6}$" Display="Dynamic" CssClass="field-error-v1"
                        ErrorMessage="IFSC should look like SBIN0001234." />
                </div>

            </div>
        </section>

    </div>


    <!-- ===================== ATTACHMENTS / DOCUMENTS ===================== -->
    <div id="tabDocs" class="tab-panel-v1">

        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-file-earmark-arrow-up"></i>Upload a document</h3>
            </div>

            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label-v1" for="<%= ddlDocType.ClientID %>">Document type</label>
                    <asp:DropDownList ID="ddlDocType" runat="server" CssClass="form-select-v1 select2-v1">
                        <asp:ListItem Text="Aadhaar card" Value="AADHAAR" />
                        <asp:ListItem Text="PAN card" Value="PAN" />
                        <asp:ListItem Text="Bank passbook / cheque" Value="BANK" />
                        <asp:ListItem Text="Appointment letter" Value="APPT" />
                        <asp:ListItem Text="Educational certificate" Value="EDU" />
                        <asp:ListItem Text="Experience letter" Value="EXP" />
                        <asp:ListItem Text="Other" Value="OTHER" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-5">
                    <label class="form-label-v1" for="<%= fuDocument.ClientID %>">File</label>
                    <asp:FileUpload ID="fuDocument" runat="server" CssClass="form-control-v1 file-v1" />
                </div>
                <div class="col-md-3">
                    <asp:LinkButton ID="btnAddDoc" runat="server" CssClass="btn btn-v1-secondary w-100"
                        CausesValidation="false" OnClick="btnAddDoc_Click"><i class="bi bi-plus-lg"></i> Add document</asp:LinkButton>
                </div>
            </div>
        </section>

        <section class="card-v1">
            <div class="sec-head">
                <h3 class="section-label"><i class="bi bi-folder2-open"></i>Uploaded documents</h3>
            </div>

            <asp:GridView ID="gvDocs" runat="server" CssClass="data-grid-v1" GridLines="None"
                AutoGenerateColumns="false" OnRowCommand="gvDocs_RowCommand">
                <Columns>
                    <asp:BoundField DataField="DocType" HeaderText="Document type" />
                    <asp:BoundField DataField="FileName" HeaderText="File name" />
                    <asp:BoundField DataField="UploadedOn" HeaderText="Uploaded on" DataFormatString="{0:dd MMM yyyy}" />
                    <asp:TemplateField ItemStyle-Width="90px">
                        <ItemTemplate>
                            <asp:LinkButton runat="server" CssClass="btn-v1-icon" CommandName="ViewDoc" CommandArgument='<%# Eval("DocId") %>'
                                CausesValidation="false" ToolTip="View"><i class="bi bi-eye"></i></asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn-v1-icon danger" CommandName="DeleteDoc" CommandArgument='<%# Eval("DocId") %>'
                                CausesValidation="false" ToolTip="Delete"><i class="bi bi-trash3"></i></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="grid-empty-v1"><i class="bi bi-folder2 d-block mb-2 fs-4"></i>No documents yet. Choose a type and file above to add one.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </section>

    </div>


    <!-- ===================== ACTION BAR ===================== -->
    <div class="action-bar">
        <span class="action-hint"><span class="required">*</span> Required fields</span>
        <div class="btn-row">
            <asp:LinkButton ID="btnCancel" runat="server" CssClass="btn btn-v1-ghost" CausesValidation="false"
                OnClick="btnCancel_Click"><i class="bi bi-x-lg"></i> Cancel</asp:LinkButton>
            <asp:LinkButton ID="btnSaveNew" runat="server" CssClass="btn btn-v1-secondary" ValidationGroup="emp"
                OnClick="btnSaveNew_Click"><i class="bi bi-plus-lg"></i> Save &amp; New</asp:LinkButton>
            <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-v1-primary" ValidationGroup="emp"
                OnClick="btnSave_Click"><i class="bi bi-check-lg"></i> Save</asp:LinkButton>
        </div>
    </div>

</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {

        /* No jQuery needed here: everything below is plain JavaScript. */

        function byId(id) { return document.getElementById(id); }
        function each(list, fn) { Array.prototype.forEach.call(list, fn); }

        function toast(icon, msg) {
            if (window.Swal) {
                Swal.fire({ toast: true, position: 'top-end', icon: icon, title: msg, showConfirmButton: false, timer: 2600, customClass: { popup: 'custom-popup' } });
            } else { alert(msg); }
        }

        /* Select2 is optional polish: used only if it was loaded */
        if (window.jQuery && jQuery.fn && jQuery.fn.select2) {
            jQuery('.select2-v1').select2({ width: '100%', minimumResultsForSearch: 8 });
        }


        /* ---------- tabs (remembered across postbacks in hfTab) ---------- */
        var tabField = byId('<%= hfTab.ClientID %>');
        var tabButtons = document.querySelectorAll('.tabs-v1 .tab-v1');
        var panels = document.querySelectorAll('.tab-panel-v1');

        function showTab(id) {
            if (!byId(id)) id = 'tabGeneral';
            each(tabButtons, function (b) { b.classList.toggle('active', b.getAttribute('data-tab') === id); });
            each(panels, function (p) { p.classList.toggle('active', p.id === id); });
            tabField.value = id;
        }
        each(tabButtons, function (b) {
            b.addEventListener('click', function () { showTab(b.getAttribute('data-tab')); });
        });
        showTab(tabField.value || 'tabGeneral');


        /* ---------- photo preview ---------- */
        var file = byId('<%= fuPhoto.ClientID %>'), box = byId('photoBox'), img = byId('photoPreview'), clearBtn = byId('btnPhotoClear');
        var savedSrc = img.getAttribute('src') || '';       // photo already stored on the server, if any

        file.addEventListener('change', function () {
            var f = file.files && file.files[0];
            if (!f) return;
            if (f.size > 2 * 1024 * 1024) { toast('warning', 'Photo must be 2 MB or smaller.'); file.value = ''; return; }
            var r = new FileReader();
            r.onload = function (e) { img.src = e.target.result; box.classList.add('has-img'); clearBtn.classList.remove('d-none'); };
            r.readAsDataURL(f);
        });

        clearBtn.addEventListener('click', function () {
            file.value = '';
            if (savedSrc) { img.src = savedSrc; } else { img.removeAttribute('src'); box.classList.remove('has-img'); }
            clearBtn.classList.add('d-none');
        });


        /* ---------- PAN / IFSC always upper-case ---------- */
        each(document.querySelectorAll('.js-upper'), function (inp) {
            inp.addEventListener('input', function () {
                var pos = inp.selectionStart;
                inp.value = inp.value.toUpperCase();
                inp.setSelectionRange(pos, pos);
            });
        });


        /* ---------- permanent address = present address ---------- */
        var pre = byId('<%= txtPresentAddr.ClientID %>'), perm = byId('<%= txtPermanentAddr.ClientID %>'), same = byId('chkSameAddr');
        function syncAddr() { if (same.checked) perm.value = pre.value; }
        same.addEventListener('change', function () { perm.readOnly = same.checked; syncAddr(); });
        pre.addEventListener('input', syncAddr);


        /* ---------- confirmation date cannot precede joining date ---------- */
        var doj = byId('<%= txtDOJ.ClientID %>'), conf = byId('<%= txtConfirmDate.ClientID %>');
        function syncConfirmMin() { if (doj.value) conf.setAttribute('min', doj.value); }
        doj.addEventListener('change', syncConfirmMin);
        syncConfirmMin();


        /* ---------- Save buttons: go to the form, then scroll to the first error ---------- */
        each(document.querySelectorAll('#<%= btnSave.ClientID %>, #<%= btnSaveNew.ClientID %>'), function (btn) {
            btn.addEventListener('click', function () {
                showTab('tabGeneral');
                setTimeout(function () {
                    var errs = document.querySelectorAll('.field-error-v1');
                    for (var i = 0; i < errs.length; i++) {
                        if (errs[i].offsetParent !== null && errs[i].textContent.replace(/\s/g, '') !== '') {
                            window.scrollTo({ top: errs[i].getBoundingClientRect().top + window.pageYOffset - 150, behavior: 'smooth' });
                            break;
                        }
                    }
                }, 60);
            });
        });
    });
</script>

</asp:Content>
