<%@ Page Title="User Master"
    Language="VB"
    MasterPageFile="~/Site1.master"
    AutoEventWireup="false"
    CodeBehind="UserMaster.aspx.vb"
    Inherits="VetanOne.UserMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .um-page { max-width: 1250px; margin: 0 auto; }

        .um-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(15, 76, 129, .07);
            margin-bottom: 18px;
            overflow: hidden;
        }

        .um-title {
            padding: 15px 20px;
            background: linear-gradient(135deg, #0f4c81, #2563eb);
            color: #fff;
            font-size: 18px;
            font-weight: 600;
        }

        .um-body { padding: 20px; }

        .um-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px 22px;
        }

        .um-field label {
            display: block;
            margin-bottom: 6px;
            color: #334155;
            font-size: 13px;
            font-weight: 600;
        }

        .req { color: #dc2626; }

        .um-input, .um-select {
            width: 100%;
            box-sizing: border-box;
            min-height: 40px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            padding: 8px 11px;
            font-size: 14px;
            color: #1e293b;
            background: #fff;
            outline: none;
        }

        .um-input:focus, .um-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,.10);
        }

        .um-actions {
            display: flex;
            gap: 9px;
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #e5e7eb;
        }

        .um-btn {
            border: 0;
            border-radius: 7px;
            padding: 9px 18px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .um-save { background: #0f4c81; color: #fff; }
        .um-save:hover { background: #0b3c67; }

        .um-new { background: #16a34a; color: #fff; }
        .um-new:hover { background: #15803d; }

        .um-cancel { background: #e2e8f0; color: #334155; }
        .um-cancel:hover { background: #cbd5e1; }

        .um-message {
            display: block;
            margin-top: 12px;
            font-size: 13px;
            font-weight: 600;
        }

        .um-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .um-list-title {
            color: #0f4c81;
            font-size: 16px;
            font-weight: 700;
        }

        .um-count {
            color: #64748b;
            font-size: 12px;
        }

        .um-table-wrap { overflow-x: auto; }

        .um-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .um-table th {
            padding: 11px 10px;
            background: #f1f5f9;
            color: #334155;
            text-align: left;
            white-space: nowrap;
            border-bottom: 1px solid #dbe3ec;
        }

        .um-table td {
            padding: 10px;
            color: #475569;
            border-bottom: 1px solid #edf2f7;
            vertical-align: middle;
        }

        .um-table tr:hover td { background: #f8fbff; }

        .um-edit {
            background: #2563eb;
            color: #fff;
            border: 0;
            border-radius: 5px;
            padding: 5px 11px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
        }

        .um-edit:hover { background: #1d4ed8; }

        .um-active {
            display: inline-block;
            padding: 4px 9px;
            border-radius: 20px;
            background: #dcfce7;
            color: #166534;
            font-size: 11px;
            font-weight: 700;
        }

        .um-inactive {
            display: inline-block;
            padding: 4px 9px;
            border-radius: 20px;
            background: #fee2e2;
            color: #991b1b;
            font-size: 11px;
            font-weight: 700;
        }

        .um-photo-box {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .um-photo {
            width: 78px;
            height: 88px;
            object-fit: cover;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #f1f5f9;
        }

        .um-file {
            width: 100%;
            font-size: 12px;
            color: #475569;
        }

        .um-photo-note {
            margin-top: 5px;
            font-size: 11px;
            color: #64748b;
        }

        .um-grid-photo { grid-column: 1 / -1; }

        @media (max-width: 700px) {
            .um-grid { grid-template-columns: 1fr; }
            .um-actions { flex-wrap: wrap; }
        }
    </style>

    <div class="um-page">

        <div class="um-card">

            <div class="um-title">
                <i class="bi bi-person-gear"></i>
                User Master
            </div>

            <div class="um-body">

                <asp:HiddenField ID="hfUserID" runat="server" Value="0" />

                <div class="um-grid">

                    <div class="um-field">
                        <label>Full Name <span class="req">*</span></label>
                        <asp:TextBox ID="txtFullName"
                            runat="server"
                            CssClass="um-input"
                            MaxLength="150" />
                    </div>

                    <div class="um-field">
                        <label>Mobile No.</label>
                        <asp:TextBox ID="txtMobileNo"
                            runat="server"
                            CssClass="um-input"
                            MaxLength="20" />
                    </div>

                    <div class="um-field">
                        <label>Email ID <span class="req">*</span></label>
                        <asp:TextBox ID="txtEmailID"
                            runat="server"
                            CssClass="um-input"
                            MaxLength="250"
                            TextMode="Email" />
                    </div>

                    <div class="um-field">
                        <label>Password <span class="req">*</span></label>
                        <asp:TextBox ID="txtPassword"
                            runat="server"
                            CssClass="um-input"
                            MaxLength="100"
                            TextMode="Password" />
                    </div>

                    <div class="um-field um-grid-photo">
                        <label>Photo</label>
                        <div class="um-photo-box">
                            <asp:Image ID="imgUserPhoto" runat="server"
                                CssClass="um-photo" ImageUrl="~/Images/no-photo.png" />
                            <div style="flex:1;">
                                <asp:FileUpload ID="fuUserPhoto" runat="server"
                                    CssClass="um-file" onchange="previewUserPhoto(this);" />
                                <div class="um-photo-note">JPG, JPEG, PNG or GIF. Maximum 2 MB.</div>
                            </div>
                        </div>
                    </div>

                    <div class="um-field">
                        <label>Active Status <span class="req">*</span></label>
                        <asp:DropDownList ID="ddlActiveStatus"
                            runat="server"
                            CssClass="um-select">
                            <asp:ListItem Text="Active" Value="1" />
                            <asp:ListItem Text="Inactive" Value="0" />
                        </asp:DropDownList>
                    </div>

                </div>

                <asp:Label ID="lblMessage"
                    runat="server"
                    CssClass="um-message" />

                <div class="um-actions">

                    <asp:Button ID="btnSave"
                        runat="server"
                        Text="Save User"
                        CssClass="um-btn um-save"
                          />

                    <asp:Button ID="btnNew"
                        runat="server"
                        Text="Save & New"
                        CssClass="um-btn um-new"
                         />

                    <asp:Button ID="btnCancel"
                        runat="server"
                        Text="Clear"
                        CssClass="um-btn um-cancel"
                        CausesValidation="False"
                          />

                </div>

            </div>
        </div>


        <div class="um-card">

            <div class="um-list-header">
                <div class="um-list-title">
                    <i class="bi bi-people"></i>
                    System Users
                </div>

                <asp:Label ID="lblUserCount"
                    runat="server"
                    CssClass="um-count" />
            </div>

            <div class="um-table-wrap">

                <asp:GridView ID="gvUsers"
                    runat="server"
                    AutoGenerateColumns="False"
                    CssClass="um-table"
                    GridLines="None"
                    DataKeyNames="UserID"
                    >

                    <Columns>

                        <asp:TemplateField HeaderText="Photo">
                            <ItemTemplate>
                                <asp:Image ID="imgGridPhoto" runat="server"
                                    CssClass="um-photo"
                                    ImageUrl='<%# If(String.IsNullOrEmpty(Eval("PhotoPath").ToString()), "~/Images/no-photo.png", Eval("PhotoPath").ToString()) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField
                            DataField="UserID"
                            HeaderText="ID" />

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Full Name" />

                        <asp:BoundField
                            DataField="MobileNo"
                            HeaderText="Mobile No." />

                        <asp:BoundField
                            DataField="EmailID"
                            HeaderText="Email ID" />

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus"
                                    runat="server"
                                    Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Active", "Inactive") %>'
                                    CssClass='<%# If(Convert.ToBoolean(Eval("IsActive")), "um-active", "um-inactive") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField
                            DataField="CreatedDate"
                            HeaderText="Created"
                            DataFormatString="{0:dd-MMM-yyyy}" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnEdit"
                                    runat="server"
                                    Text="Edit"
                                    CommandName="EditUser"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CssClass="um-edit"
                                    CausesValidation="False" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </div>

    </div>


    <script type="text/javascript">
        function previewUserPhoto(input) {
            if (!input.files || !input.files[0]) return;
            var file = input.files[0];
            if (!file.type.match(/^image\//)) {
                alert("Please select an image file.");
                input.value = "";
                return;
            }
            if (file.size > 2 * 1024 * 1024) {
                alert("Photo size must not exceed 2 MB.");
                input.value = "";
                return;
            }
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('<%= imgUserPhoto.ClientID %>').src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    </script>

</asp:Content>
