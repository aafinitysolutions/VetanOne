<%@ Page Title="Customer Master" Language="VB" MasterPageFile="~/Site1.master"
    AutoEventWireup="false" CodeBehind="CustomerMaster.aspx.vb"
    Inherits="VetanOne.CustomerMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .customer-page {
            padding: 20px;
        }

        .customer-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(15,76,129,.08);
            overflow: hidden;
        }

        .customer-header {
            background: linear-gradient(135deg,#0f4c81,#2563eb);
            color: white;
            padding: 18px 22px;
        }

        .customer-header h4 {
            margin: 0;
            font-weight: 700;
        }

        .customer-header small {
            opacity: .85;
        }

        .section-title {
            color: #0f4c81;
            font-size: 15px;
            font-weight: 700;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 8px;
            margin-bottom: 16px;
        }

        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 5px;
        }

        .form-control,
        .form-select {
            min-height: 39px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 .2rem rgba(37,99,235,.12);
        }

        .required {
            color: #dc3545;
        }

        .app-box {
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 12px 14px;
            background: #f8fafc;
            height: 100%;
        }

        .app-title {
            font-size: 13px;
            font-weight: 700;
            color: #374151;
            margin-bottom: 8px;
        }

        .service-box {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 12px;
            padding: 15px;
        }

        .btn-save {
            background: #198754;
            color: #fff;
            border: 0;
        }

        .btn-save:hover {
            background: #157347;
            color: #fff;
        }

        .grid-wrap {
            overflow-x: auto;
        }

        .customer-grid {
            width: 100%;
            border-collapse: collapse;
        }

        .customer-grid th {
            background: #0f4c81;
            color: #fff;
            padding: 10px;
            font-size: 13px;
            white-space: nowrap;
        }

        .customer-grid td {
            padding: 9px 10px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }

        .customer-grid tr:hover td {
            background: #f8fafc;
        }

        .status-active {
            color: #198754;
            font-weight: 700;
        }

        .status-inactive {
            color: #dc3545;
            font-weight: 700;
        }

        .customer-code {
            background: #eef4ff;
            color: #0f4c81;
            font-weight: 700;
        }
    </style>

    <div class="customer-page">

        <!-- CUSTOMER ENTRY -->
        <div class="customer-card mb-4">

            <div class="customer-header">
                <h4>
                    <i class="bi bi-people-fill me-2"></i>
                    Customer Master
                </h4>

                <small>
                    Maintain customer, statutory and service charge information
                </small>
            </div>

            <div class="p-4">

                <asp:HiddenField ID="hfCustomerID" runat="server" />

                <!-- CUSTOMER INFORMATION -->
                <div class="section-title">
                    <i class="bi bi-building me-2"></i>
                    Customer Information
                </div>

                <div class="row g-3">

                    <div class="col-md-3">
                        <label class="form-label">Customer Code</label>

                        <asp:TextBox
                            ID="txtCustomerCode"
                            runat="server"
                            CssClass="form-control customer-code"
                            MaxLength="30"
                            placeholder="Auto / Customer Code">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">
                            Customer Name <span class="required">*</span>
                        </label>

                        <asp:TextBox
                            ID="txtCustomerName"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="200"
                            placeholder="Enter customer / company name">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Status</label>

                        <asp:DropDownList
                            ID="ddlStatus"
                            runat="server"
                            CssClass="form-select">

                            <asp:ListItem
                                Text="Active"
                                Value="1"
                                Selected="True">
                            </asp:ListItem>

                            <asp:ListItem
                                Text="Inactive"
                                Value="0">
                            </asp:ListItem>

                        </asp:DropDownList>
                    </div>

                </div>


                <!-- ADDRESS -->
                <div class="section-title mt-4">
                    <i class="bi bi-geo-alt me-2"></i>
                    Address & Contact Information
                </div>

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label">Address Line 1</label>

                        <asp:TextBox
                            ID="txtAddress1"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="250">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Address Line 2</label>

                        <asp:TextBox
                            ID="txtAddress2"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="250">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">City</label>

                        <asp:TextBox
                            ID="txtCity"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="100">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">State</label>

                        <asp:TextBox
                            ID="txtState"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="100">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">State Code</label>

                        <asp:TextBox
                            ID="txtStateCode"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="10"
                            placeholder="e.g. 27">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">PIN Code</label>

                        <asp:TextBox
                            ID="txtPINCode"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="10">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Mobile No.</label>

                        <asp:TextBox
                            ID="txtMobileNo"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="20">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Contact Person</label>

                        <asp:TextBox
                            ID="txtContactPerson"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="150">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Email ID</label>

                        <asp:TextBox
                            ID="txtEmailID"
                            runat="server"
                            CssClass="form-control"
                            MaxLength="250"
                            TextMode="Email">
                        </asp:TextBox>
                    </div>

                </div>


                <!-- GST / PAN -->
                <div class="section-title mt-4">
                    <i class="bi bi-file-earmark-text me-2"></i>
                    Tax & Statutory Information
                </div>

                <div class="row g-3">

                    <div class="col-md-4">
                        <label class="form-label">GST No. / GSTIN</label>

                        <asp:TextBox
                            ID="txtGSTNo"
                            runat="server"
                            CssClass="form-control text-uppercase"
                            MaxLength="30"
                            placeholder="GSTIN">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">PAN No.</label>

                        <asp:TextBox
                            ID="txtPANNo"
                            runat="server"
                            CssClass="form-control text-uppercase"
                            MaxLength="20"
                            placeholder="PAN">
                        </asp:TextBox>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">PF Registration / Code</label>

                        <asp:TextBox
                            ID="txtPFCode"
                            runat="server"
                            CssClass="form-control text-uppercase"
                            MaxLength="50"
                            placeholder="PF Code">
                        </asp:TextBox>
                    </div>

                </div>


                <!-- APPLICABILITY -->
                <div class="section-title mt-4">
                    <i class="bi bi-shield-check me-2"></i>
                    Statutory Applicability
                </div>

                <div class="row g-3">

                    <div class="col-md-4">
                        <div class="app-box">

                            <div class="app-title">
                                <i class="bi bi-person-badge me-2"></i>
                                PF Applicable
                            </div>

                            <asp:RadioButtonList
                                ID="rblPF"
                                runat="server"
                                RepeatDirection="Horizontal"
                                CssClass="d-flex gap-4">

                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>

                            </asp:RadioButtonList>

                        </div>
                    </div>


                    <div class="col-md-4">
                        <div class="app-box">

                            <div class="app-title">
                                <i class="bi bi-heart-pulse me-2"></i>
                                ESIC Applicable
                            </div>

                            <asp:RadioButtonList
                                ID="rblESIC"
                                runat="server"
                                RepeatDirection="Horizontal"
                                CssClass="d-flex gap-4">

                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>

                            </asp:RadioButtonList>

                        </div>
                    </div>


                    <div class="col-md-4">
                        <div class="app-box">

                            <div class="app-title">
                                <i class="bi bi-bank me-2"></i>
                                LWF Applicable
                            </div>

                            <asp:RadioButtonList
                                ID="rblLWF"
                                runat="server"
                                RepeatDirection="Horizontal"
                                CssClass="d-flex gap-4">

                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>

                            </asp:RadioButtonList>

                        </div>
                    </div>

                </div>


                <!-- SERVICE CHARGES -->
                <div class="section-title mt-4">
                    <i class="bi bi-currency-rupee me-2"></i>
                    Service Charge / Billing Configuration
                </div>

                <div class="service-box">

                    <div class="row g-3">

                        <div class="col-md-4">
                            <label class="form-label">
                                Service Charge Type
                            </label>

                            <asp:DropDownList
                                ID="ddlServiceChargeType"
                                runat="server"
                                CssClass="form-select">

                                <asp:ListItem
                                    Text="Percentage (%)"
                                    Value="PERCENTAGE"
                                    Selected="True">
                                </asp:ListItem>

                                <asp:ListItem
                                    Text="Fixed Amount"
                                    Value="FIXED">
                                </asp:ListItem>

                            </asp:DropDownList>
                        </div>


                        <div class="col-md-4">
                            <label class="form-label">
                                Service Charge
                            </label>

                            <div class="input-group">

                                <span class="input-group-text">
                                    <i class="bi bi-currency-rupee"></i>
                                </span>

                                <asp:TextBox
                                    ID="txtServiceCharge"
                                    runat="server"
                                    CssClass="form-control"
                                    MaxLength="15"
                                    placeholder="0.00">
                                </asp:TextBox>

                            </div>

                            <small class="text-muted">
                                Percentage or fixed amount according to the selected type.
                            </small>
                        </div>


                        <div class="col-md-4">
                            <label class="form-label">
                                Billing Cycle
                            </label>

                            <asp:DropDownList
                                ID="ddlBillingCycle"
                                runat="server"
                                CssClass="form-select">

                                <asp:ListItem Text="Monthly" Value="MONTHLY" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Weekly" Value="WEEKLY"></asp:ListItem>
                                <asp:ListItem Text="Fortnightly" Value="FORTNIGHTLY"></asp:ListItem>

                            </asp:DropDownList>
                        </div>

                    </div>

                </div>


                <!-- BUTTONS -->
                <div class="d-flex gap-2 mt-4">

                    <asp:Button
                        ID="btnSave"
                        runat="server"
                        Text="Save Customer"
                        CssClass="btn btn-save px-4"
                         />

                    <asp:Button
                        ID="btnSaveNew"
                        runat="server"
                        Text="Save & New"
                        CssClass="btn btn-primary px-4"
                         />

                    <asp:Button
                        ID="btnClear"
                        runat="server"
                        Text="Clear"
                        CssClass="btn btn-outline-secondary px-4"
                        CausesValidation="false"
                         />

                </div>


                <asp:Label
                    ID="lblMessage"
                    runat="server"
                    CssClass="d-block mt-3">
                </asp:Label>

            </div>

        </div>


        <!-- CUSTOMER LIST -->
        <div class="customer-card">

            <div class="p-3 border-bottom d-flex justify-content-between align-items-center">

                <div>
                    <h5 class="mb-0 text-primary">
                        <i class="bi bi-list-ul me-2"></i>
                        Customer List
                    </h5>

                    <small class="text-muted">
                        Customers available for employee deployment
                    </small>
                </div>

            </div>


            <div class="grid-wrap">

                <asp:GridView
                    ID="gvCustomers"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="customer-grid"
                    GridLines="None"
                    DataKeyNames="CustomerID"
                   >

                    <Columns>

                        <asp:BoundField
                            DataField="CustomerCode"
                            HeaderText="Code" />

                        <asp:BoundField
                            DataField="CustomerName"
                            HeaderText="Customer Name" />

                        <asp:BoundField
                            DataField="City"
                            HeaderText="City" />

                        <asp:BoundField
                            DataField="State"
                            HeaderText="State" />

                        <asp:BoundField
                            DataField="StateCode"
                            HeaderText="State Code" />

                        <asp:BoundField
                            DataField="GSTNo"
                            HeaderText="GSTIN" />

                        <asp:BoundField
                            DataField="PANNo"
                            HeaderText="PAN" />

                        <asp:TemplateField HeaderText="PF">
                            <ItemTemplate>

                                <%# If(Convert.ToBoolean(Eval("PFApplicable")),
                                    "<span class='text-success fw-bold'>Yes</span>",
                                    "<span class='text-muted'>No</span>") %>

                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="ESIC">
                            <ItemTemplate>

                                <%# If(Convert.ToBoolean(Eval("ESICApplicable")),
                                    "<span class='text-success fw-bold'>Yes</span>",
                                    "<span class='text-muted'>No</span>") %>

                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="LWF">
                            <ItemTemplate>

                                <%# If(Convert.ToBoolean(Eval("LWFApplicable")),
                                    "<span class='text-success fw-bold'>Yes</span>",
                                    "<span class='text-muted'>No</span>") %>

                            </ItemTemplate>
                        </asp:TemplateField>


                        <asp:BoundField
                            DataField="ServiceCharge"
                            HeaderText="Service Charge" />


                        <asp:BoundField
                            DataField="ServiceChargeType"
                            HeaderText="Charge Type" />


                        <asp:TemplateField HeaderText="Status">

                            <ItemTemplate>

                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")),
                                    "status-active",
                                    "status-inactive") %>'>

                                    <%# If(Convert.ToBoolean(Eval("IsActive")),
                                        "Active",
                                        "Inactive") %>

                                </span>

                            </ItemTemplate>

                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Action">

                            <ItemTemplate>

                                <asp:LinkButton
                                    ID="lnkEdit"
                                    runat="server"
                                    CommandName="EditCustomer"
                                    CommandArgument='<%# Eval("CustomerID") %>'
                                    CssClass="btn btn-sm btn-outline-primary">

                                    <i class="bi bi-pencil-square"></i>
                                    Edit

                                </asp:LinkButton>

                            </ItemTemplate>

                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </div>

    </div>

</asp:Content>