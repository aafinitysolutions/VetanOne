<%@ Page Title="Company Master" Language="VB" MasterPageFile="~/Site1.master"
    AutoEventWireup="false" CodeBehind="CompanyMaster.aspx.vb"
    Inherits="VetanOne.CompanyMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .cm-page { padding: 20px; }
        .cm-card {
            background:#fff; border:1px solid #e5e7eb; border-radius:14px;
            box-shadow:0 4px 16px rgba(15,76,129,.08); overflow:hidden;
        }
        .cm-header {
            background:linear-gradient(135deg,#0f4c81,#2563eb);
            color:#fff; padding:18px 22px;
        }
        .cm-header h4 { margin:0; font-weight:700; }
        .cm-header small { opacity:.85; }
        .cm-section {
            font-size:15px; font-weight:700; color:#0f4c81;
            border-bottom:1px solid #e5e7eb; padding-bottom:8px; margin:4px 0 16px;
        }
        .form-label { font-size:13px; font-weight:600; color:#374151; margin-bottom:5px; }
        .form-control, .form-select {
            border-radius:8px; border:1px solid #d1d5db; min-height:39px;
        }
        .form-control:focus, .form-select:focus {
            border-color:#2563eb; box-shadow:0 0 0 .2rem rgba(37,99,235,.12);
        }
        .logo-box {
            border:1px dashed #b8c4d3; border-radius:12px; padding:12px;
            text-align:center; background:#f8fafc;
        }
        .logo-preview {
            width:120px; height:80px; object-fit:contain;
            border-radius:8px; background:#fff; border:1px solid #e5e7eb;
            margin-bottom:8px;
        }
        .btn-save { background:#198754; color:#fff; border:0; }
        .btn-save:hover { background:#157347; color:#fff; }
        .grid-wrap { overflow-x:auto; }
        .cm-grid { width:100%; border-collapse:collapse; }
        .cm-grid th {
            background:#0f4c81; color:#fff; padding:10px; font-size:13px;
            white-space:nowrap;
        }
        .cm-grid td { padding:9px 10px; border-bottom:1px solid #e5e7eb; font-size:13px; }
        .cm-grid tr:hover td { background:#f8fafc; }
        .company-logo-grid { width:48px; height:38px; object-fit:contain; border-radius:5px; border:1px solid #e5e7eb; }
        .status-active { color:#198754; font-weight:700; }
        .status-inactive { color:#dc3545; font-weight:700; }
        .required { color:#dc3545; }
    </style>

    <div class="cm-page">
        <div class="cm-card mb-4">
            <div class="cm-header">
                <h4><i class="bi bi-building me-2"></i>Company Master</h4>
                <small>Maintain company profile, contact and statutory information</small>
            </div>

            <div class="p-4">
                <asp:HiddenField ID="hfCompanyID" runat="server" />

                <div class="cm-section"><i class="bi bi-building me-2"></i>Company Information</div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Company Name <span class="required">*</span></label>
                        <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control"
                            MaxLength="200" placeholder="Enter company name"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Short Name</label>
                        <asp:TextBox ID="txtShortName" runat="server" CssClass="form-control"
                            MaxLength="100" placeholder="Short name"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Active" Value="1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="cm-section mt-4"><i class="bi bi-geo-alt me-2"></i>Address & Contact</div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Address Line 1</label>
                        <asp:TextBox ID="txtAddress1" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Address Line 2</label>
                        <asp:TextBox ID="txtAddress2" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">City</label>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">State</label>
                        <asp:TextBox ID="txtState" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">PIN Code</label>
                        <asp:TextBox ID="txtPIN" runat="server" CssClass="form-control" MaxLength="10"></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Country</label>
                        <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Mobile No.</label>
                        <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Phone No.</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="30"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Email ID</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Website</label>
                        <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                    </div>
                </div>

                <div class="cm-section mt-4"><i class="bi bi-file-earmark-text me-2"></i>Statutory Information</div>
                <div class="row g-3">
                    <div class="col-md-3"><label class="form-label">PAN</label><asp:TextBox ID="txtPAN" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox></div>
                    <div class="col-md-3"><label class="form-label">TAN</label><asp:TextBox ID="txtTAN" runat="server" CssClass="form-control" MaxLength="20"></asp:TextBox></div>
                    <div class="col-md-3"><label class="form-label">GSTIN</label><asp:TextBox ID="txtGSTIN" runat="server" CssClass="form-control" MaxLength="30"></asp:TextBox></div>
                    <div class="col-md-3"><label class="form-label">PF Code</label><asp:TextBox ID="txtPFCode" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox></div>
                    <div class="col-md-4"><label class="form-label">ESIC Code</label><asp:TextBox ID="txtESICCode" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox></div>
                    <div class="col-md-4"><label class="form-label">PT Registration No.</label><asp:TextBox ID="txtPTNo" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox></div>
                    <div class="col-md-4"><label class="form-label">LWF Registration No.</label><asp:TextBox ID="txtLWFNo" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox></div>
                </div>

                <div class="cm-section mt-4"><i class="bi bi-image me-2"></i>Company Logo</div>
                <div class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <div class="logo-box">
                            <asp:Image ID="imgLogo" runat="server" CssClass="logo-preview" ImageUrl="~/Images/no-photo.png" />
                            <br />
                            <asp:FileUpload ID="fuLogo" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png,.gif"
                                onchange="previewCompanyLogo(this);" />
                            <small class="text-muted d-block mt-2">JPG, JPEG, PNG or GIF. Maximum 2 MB.</small>
                        </div>
                    </div>
                    <div class="col-md-8">
                        <div class="alert alert-light border mb-0">
                            <i class="bi bi-info-circle me-2 text-primary"></i>
                            The logo is stored in <strong>CompanyLogos</strong> and its path is maintained with the company record.
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <asp:Button ID="btnSave" runat="server" Text="Save Company"
                        CssClass="btn btn-save px-4"   />
                    <asp:Button ID="btnSaveNew" runat="server" Text="Save & New"
                        CssClass="btn btn-primary px-4"   />
                    <asp:Button ID="btnClear" runat="server" Text="Clear"
                        CssClass="btn btn-outline-secondary px-4" CausesValidation="false"   />
                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="d-block mt-3"></asp:Label>
            </div>
        </div>

        <div class="cm-card">
            <div class="p-3 border-bottom">
                <h5 class="mb-0 text-primary"><i class="bi bi-list-ul me-2"></i>Companies</h5>
            </div>
            <div class="grid-wrap">
                <asp:GridView ID="gvCompanies" runat="server" AutoGenerateColumns="False"
                    CssClass="cm-grid" GridLines="None" DataKeyNames="CompanyID"
                    >
                    <Columns>
                        <asp:TemplateField HeaderText="Logo">
                            <ItemTemplate>
                                <asp:Image ID="gvLogo" runat="server" CssClass="company-logo-grid"
                                    ImageUrl='<%# GetLogoUrl(Eval("LogoPath")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CompanyID" HeaderText="ID" />
                        <asp:BoundField DataField="CompanyName" HeaderText="Company Name" />
                        <asp:BoundField DataField="ShortName" HeaderText="Short Name" />
                        <asp:BoundField DataField="City" HeaderText="City" />
                        <asp:BoundField DataField="State" HeaderText="State" />
                        <asp:BoundField DataField="GSTIN" HeaderText="GSTIN" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# If(Convert.ToBoolean(Eval("IsActive")), "status-active", "status-inactive") %>'>
                                    <%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Inactive") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditCompany"
                                    CommandArgument='<%# Eval("CompanyID") %>' CssClass="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil-square"></i> Edit
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function previewCompanyLogo(input) {
            if (input.files && input.files[0]) {
                var file = input.files[0];
                if (file.size > 2 * 1024 * 1024) {
                    alert("Company logo must not exceed 2 MB.");
                    input.value = "";
                    return;
                }
                var reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('<%= imgLogo.ClientID %>').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }
    </script>
</asp:Content>
