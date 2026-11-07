<%@ Page Title="Leave Approval"
    Language="VB"
    MasterPageFile="~/Site1.master"
    AutoEventWireup="false"
    CodeBehind="LeaveApproval.aspx.vb"
    Inherits="VetanOne.LeaveApproval" %>


<asp:Content ID="ContentHeader" ContentPlaceHolderID="HeaderActions" runat="server">
    <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-select-v1" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_Changed">
        <asp:ListItem Text="Pending" Value="Pending" Selected="True"></asp:ListItem>
        <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
        <asp:ListItem Text="Partially Approved" Value="PartiallyApproved"></asp:ListItem>
        <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
        <asp:ListItem Text="All" Value=""></asp:ListItem>
    </asp:DropDownList>
</asp:Content>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="flex-v1-between mb-v1-3">
        <span class="text-muted-v1" style="font-size:13px;">
            <asp:Literal ID="litResultCount" runat="server" Text="0 requests"></asp:Literal>
        </span>
    </div>

    <asp:GridView ID="gvLeave" runat="server"
        AutoGenerateColumns="False"
        CssClass="data-grid-v1"
        GridLines="None"
        
        AllowPaging="True"
        PageSize="10"
        DataKeyNames="LeaveRequestId"
        OnRowCommand="gvLeave_RowCommand"
        OnPageIndexChanging="gvLeave_PageIndexChanging"
        >

        <EmptyDataTemplate>
            <div class="grid-empty-v1">
                <i class="bi bi-calendar-check" style="font-size:22px;display:block;margin-bottom:8px;"></i>
                No leave requests to review right now.
            </div>
        </EmptyDataTemplate>

        <PagerStyle CssClass="grid-pager-v1" />

        <Columns>

            <asp:TemplateField HeaderText="Employee">
                <ItemTemplate>
                    <div class="flex-v1 flex-v1-gap-3">
                        <div class="avatar-v1"><%# Left(Eval("EmpName").ToString(), 1) %></div>
                        <div>
                            <div style="font-weight:600;"><%# Eval("EmpName") %></div>
                            <div class="text-faint-v1" style="font-size:12px;"><%# Eval("Department") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Leave Type">
                <ItemTemplate>
                    <span class="pill-v1 pill-v1-neutral"><%# Eval("LeaveType") %></span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Dates">
                <ItemTemplate>
                    <%# FormatDate(Eval("FromDate")) %> &rarr; <%# FormatDate(Eval("ToDate")) %>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="TotalDays" HeaderText="Days" ItemStyle-CssClass="num" HeaderStyle-CssClass="num" />

            <asp:TemplateField HeaderText="Reason">
                <ItemTemplate>
                    <span class="text-muted-v1" title='<%# Eval("Reason") %>'>
                        <%# Left(Eval("Reason").ToString(), 40) %><%# If(Eval("Reason").ToString().Length > 40, "…", "") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='pill-v1 <%# StatusPillClass(Eval("Status").ToString()) %>'>
                        <span class="dot"></span><%# Eval("Status") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Right">
                <ItemTemplate>
                    <asp:LinkButton ID="btnReview" runat="server" CssClass="btn btn-v1-secondary"
                        CommandName="Review" CommandArgument='<%# Eval("LeaveRequestId") %>'>
                        <i class="bi bi-eye"></i> Review
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>

    </asp:GridView>


    <%-- =========================================================
         REVIEW DRAWER — per-day checkbox editor
         ========================================================= --%>

    <div class="drawer-backdrop-v1" id="drawerBackdrop" onclick="closeDrawer()"></div>

    <asp:Panel ID="pnlDrawer" runat="server" CssClass="drawer-v1" ClientIDMode="Static">

        <div class="drawer-v1-head">
            <div>
                <span class="page-eyebrow" style="margin-bottom:2px;">Review request</span>
                <h2 style="margin:0;font-size:18px;">
                    <asp:Literal ID="litDrawerEmpName" runat="server"></asp:Literal>
                </h2>
            </div>
            <button type="button" class="btn-v1-ghost" onclick="closeDrawer()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <div class="drawer-v1-body">

            <asp:HiddenField ID="hfLeaveRequestId" runat="server" Value="0" />

            <div class="card-v1-flat mb-v1-4">
                <div class="employee-info-row" style="display:flex;justify-content:space-between;font-size:13px;padding:5px 0;">
                    <span class="text-faint-v1">Department</span>
                    <span style="font-weight:600;"><asp:Literal ID="litDrawerDept" runat="server"></asp:Literal></span>
                </div>
                <div class="employee-info-row" style="display:flex;justify-content:space-between;font-size:13px;padding:5px 0;">
                    <span class="text-faint-v1">Leave Type</span>
                    <span style="font-weight:600;"><asp:Literal ID="litDrawerLeaveType" runat="server"></asp:Literal></span>
                </div>
                <div class="employee-info-row" style="display:flex;justify-content:space-between;font-size:13px;padding:5px 0;">
                    <span class="text-faint-v1">Reason given</span>
                    <span style="font-weight:600;"><asp:Literal ID="litDrawerReason" runat="server"></asp:Literal></span>
                </div>
            </div>

            <div class="section-label"><i class="bi bi-calendar3"></i>Days requested</div>
            <p class="text-faint-v1" style="font-size:12.5px;margin-top:-10px;">
                Uncheck any day you don't want to approve. Weekends are excluded automatically.
            </p>

            <div id="dayList" style="border:1px solid var(--border);border-radius:var(--radius-m);overflow:hidden;">
                <asp:Repeater ID="rptDays" runat="server">
                    <ItemTemplate>
                        <label style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-bottom:1px solid var(--border);font-size:13.5px;cursor:pointer;">
                            <asp:CheckBox ID="chkDay" runat="server" Checked="true" CssClass="day-checkbox" />
                            <asp:HiddenField ID="hfDayDate" runat="server" Value='<%# Eval("IsoDate") %>' />
                            <span><%# Eval("DisplayDate") %></span>
                        </label>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="flex-v1-between mt-v1-3" style="font-size:13px;">
                <span class="text-muted-v1">Approved days</span>
                <strong id="dayCounter" style="font-family:var(--font-display);font-size:16px;">0 / 0</strong>
            </div>

            <div class="form-group-v1 mt-v1-4">
                <label class="form-label-v1">Rejection reason <span id="reasonRequiredMark" class="required" style="display:none;">*</span></label>
                <asp:TextBox ID="txtRejectionReason" runat="server" TextMode="MultiLine" CssClass="form-control-v1" placeholder="Required if any day is unchecked, or if rejecting the whole request"></asp:TextBox>
            </div>

            <asp:Label ID="lblDrawerMessage" runat="server" CssClass="alert-v1 mt-v1-3"></asp:Label>

        </div>

        <div class="drawer-v1-foot">
            <asp:Button ID="btnReject" runat="server" Text="Reject Request" CssClass="btn btn-v1-danger" OnClick="btnReject_Click" />
            <asp:Button ID="btnApprove" runat="server" Text="Approve Selected Days" CssClass="btn btn-v1-primary" OnClick="btnApprove_Click" />
        </div>

    </asp:Panel>


    <script>

        var drawer = document.getElementById('<%= pnlDrawer.ClientID %>');
        var drawerBackdrop = document.getElementById('drawerBackdrop');

        function openDrawer() {
            drawer.classList.add('open');
            drawerBackdrop.classList.add('show');
            refreshDayCounter();
        }
        function closeDrawer() {
            drawer.classList.remove('open');
            drawerBackdrop.classList.remove('show');
        }

        function refreshDayCounter() {
            var boxes = document.querySelectorAll('.day-checkbox');
            var total = boxes.length;
            var checked = 0;
            boxes.forEach(function (b) { if (b.checked) checked++; });

            var counter = document.getElementById('dayCounter');
            if (counter) counter.textContent = checked + ' / ' + total;

            var mark = document.getElementById('reasonRequiredMark');
            if (mark) mark.style.display = (checked < total) ? 'inline' : 'none';
        }

        document.addEventListener('change', function (e) {
            if (e.target.classList && e.target.classList.contains('day-checkbox')) {
                refreshDayCounter();
            }
        });

        //(function () {
        //    if (window.__reopenDrawer === true) { openDrawer(); }
        //})();

    </script>

</asp:Content>
