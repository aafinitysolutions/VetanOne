<%@ Page Title="Menu Access" Language="VB" MasterPageFile="~/Site1.master"
    AutoEventWireup="false" CodeBehind="MenuAccess.aspx.vb"
    Inherits="VetanOne.MenuAccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
.ma-page{max-width:1250px;margin:0 auto}.ma-card{background:#fff;border:1px solid #e2e8f0;border-radius:12px;box-shadow:0 4px 18px rgba(15,76,129,.07);overflow:hidden}
.ma-title{padding:15px 20px;background:linear-gradient(135deg,#0f4c81,#2563eb);color:#fff;font-size:18px;font-weight:600}
.ma-toolbar{display:flex;align-items:center;gap:12px;padding:16px 20px;background:#f8fafc;border-bottom:1px solid #e2e8f0}
.ma-toolbar label{font-size:13px;font-weight:600;color:#334155}.ma-select{min-width:320px;min-height:40px;border:1px solid #cbd5e1;border-radius:7px;padding:7px 10px;background:#fff}
.ma-body{overflow-x:auto}.ma-table{width:100%;border-collapse:collapse;font-size:13px}.ma-table th{padding:11px 10px;background:#f1f5f9;color:#334155;border-bottom:1px solid #dbe3ec;text-align:center;white-space:nowrap}
.ma-table th:first-child,.ma-table td:first-child{text-align:left}.ma-table td{padding:9px 10px;border-bottom:1px solid #edf2f7;color:#475569;text-align:center;vertical-align:middle}
.ma-table tr:hover td{background:#f8fbff}.ma-check{width:18px;height:18px;cursor:pointer;accent-color:#2563eb}.ma-actions{display:flex;gap:9px;padding:16px 20px;border-top:1px solid #e2e8f0;background:#f8fafc}
.ma-btn{border:0;border-radius:7px;padding:9px 18px;font-size:13px;font-weight:600;cursor:pointer}.ma-save{background:#0f4c81;color:#fff}.ma-all{background:#16a34a;color:#fff}.ma-clear{background:#e2e8f0;color:#334155}
.ma-message{display:block;padding:0 20px 12px;font-size:13px;font-weight:600}
@media(max-width:700px){.ma-toolbar{align-items:flex-start;flex-direction:column}.ma-select{min-width:100%}.ma-table{min-width:800px}}
</style>

<div class="ma-page"><div class="ma-card">
<div class="ma-title"><i class="bi bi-key"></i> Menu Access</div>

<div class="ma-toolbar">
<label>Select User</label>
<asp:DropDownList ID="ddlUser" runat="server" CssClass="ma-select"
    AutoPostBack="True"   />
</div>

<div class="ma-body">
<asp:GridView ID="gvMenuAccess" runat="server" AutoGenerateColumns="False"
    CssClass="ma-table" GridLines="None" DataKeyNames="MenuID">

<Columns>
<asp:BoundField DataField="MenuName" HeaderText="Menu" />

<asp:TemplateField HeaderText="View"><ItemTemplate>
<asp:CheckBox ID="chkView" runat="server" CssClass="ma-check"
    Checked='<%# Convert.ToBoolean(Eval("CanView")) %>' />
</ItemTemplate></asp:TemplateField>

<asp:TemplateField HeaderText="Add"><ItemTemplate>
<asp:CheckBox ID="chkAdd" runat="server" CssClass="ma-check"
    Enabled='<%# Not Convert.ToBoolean(Eval("IsParent")) %>'
    Checked='<%# Convert.ToBoolean(Eval("CanAdd")) %>' />
</ItemTemplate></asp:TemplateField>

<asp:TemplateField HeaderText="Edit"><ItemTemplate>
<asp:CheckBox ID="chkEdit" runat="server" CssClass="ma-check"
    Enabled='<%# Not Convert.ToBoolean(Eval("IsParent")) %>'
    Checked='<%# Convert.ToBoolean(Eval("CanEdit")) %>' />
</ItemTemplate></asp:TemplateField>

<asp:TemplateField HeaderText="Delete"><ItemTemplate>
<asp:CheckBox ID="chkDelete" runat="server" CssClass="ma-check"
    Enabled='<%# Not Convert.ToBoolean(Eval("IsParent")) %>'
    Checked='<%# Convert.ToBoolean(Eval("CanDelete")) %>' />
</ItemTemplate></asp:TemplateField>
</Columns>
</asp:GridView>
</div>

<asp:Label ID="lblMessage" runat="server" CssClass="ma-message" />

<div class="ma-actions">
<asp:Button ID="btnSave" runat="server" Text="Save Access"
    CssClass="ma-btn ma-save"   />
<asp:Button ID="btnSelectAll" runat="server" Text="Select All"
    CssClass="ma-btn ma-all" CausesValidation="False"   />
<asp:Button ID="btnClearAll" runat="server" Text="Clear All"
    CssClass="ma-btn ma-clear" CausesValidation="False"   />
</div>
</div></div>
</asp:Content>
