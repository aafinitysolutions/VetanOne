<%@ Page Title="Leave Application"
    Language="VB"
    MasterPageFile="~/Site1.master"
    AutoEventWireup="false"
    CodeBehind="LeaveApplication.aspx.vb"
    Inherits="VetanOne.LeaveApplication" %>

<asp:Content ID="Content1"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,600&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">

    <style>

        /* =====================================================
           TOKENS
           ===================================================== */

        .leave-page {
            --bg: #F1F3EF;
            --surface: #ffffff;
            --ink: #16241F;
            --ink-soft: #5B665F;
            --ink-faint: #93998F;
            --primary: #1F5C4F;
            --primary-soft: #E4EEE9;
            --accent: #D98A3D;
            --accent-soft: #FBEBD6;
            --border: #DEE4DE;
            --approved: #3F8361;
            --pending: #C98A2B;
            --rejected: #B8493F;
            --weekend: #F4F5F2;
            --radius-s: 6px;
            --radius-m: 12px;

            background: var(--bg);
            padding: 20px;
            font-family: 'IBM Plex Sans', sans-serif;
            color: var(--ink);
        }

        .leave-page * { box-sizing: border-box; }


        /* =====================================================
           CARD / HEADER
           ===================================================== */

        .leave-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-m);
            overflow: hidden;
        }

        .leave-header {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 20px 24px 16px;
        }

        .leave-header h4 {
            margin: 0 0 4px;
            font-family: 'Fraunces', serif;
            font-weight: 500;
            font-size: 22px;
            color: var(--ink);
        }

        .leave-header h4 i { color: var(--primary); }

        .leave-header small {
            color: var(--ink-soft);
        }


        /* =====================================================
           TABS
           ===================================================== */

        .leave-tabs {
            border-bottom: 1px solid var(--border);
            background: var(--surface);
            padding: 0 24px;
        }

        .leave-tab {
            border: 0;
            background: transparent;
            color: var(--ink-soft);
            font-weight: 600;
            font-size: 13.5px;
            padding: 13px 18px;
            border-bottom: 2px solid transparent;
        }

        .leave-tab:hover {
            color: var(--primary);
        }

        .leave-tab.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }


        /* =====================================================
           SECTION LABEL
           ===================================================== */

        .leave-section {
            font-family: 'Fraunces', serif;
            font-size: 16px;
            font-weight: 500;
            color: var(--ink);
            margin: 4px 0 14px;
        }

        .leave-section i { color: var(--primary); }


        /* =====================================================
           LEAVE TYPE CHIPS (mirrors ddlLeaveType)
           ===================================================== */

        .lt-chip-row {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }

        .lt-chip {
            border: 1.5px solid var(--border);
            background: var(--surface);
            border-radius: 999px;
            padding: 8px 14px;
            font-size: 13.5px;
            cursor: pointer;
            color: var(--ink);
            display: inline-flex;
            align-items: center;
            gap: 7px;
        }

        .lt-chip .dot {
            width: 7px; height: 7px; border-radius: 50%;
            background: var(--ink-faint);
        }

        .lt-chip.sel {
            border-color: var(--primary);
            background: var(--primary-soft);
            color: var(--primary);
            font-weight: 600;
        }

        .lt-chip.sel .dot { background: var(--primary); }

        /* the real ASP.NET DropDownList stays functional but visually hidden;
           it remains the actual postback value the chips control */
        .ddl-source {
            position: absolute;
            width: 1px; height: 1px;
            opacity: 0; overflow: hidden;
            clip: rect(0 0 0 0);
        }


        /* =====================================================
           DATE RANGE + CALENDAR
           ===================================================== */

        .date-trigger {
            border: 1px solid var(--border);
            border-radius: var(--radius-s);
            background: var(--surface);
            padding: 11px 14px;
            font-size: 13.5px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: var(--ink);
        }

        .date-trigger .ph { color: var(--ink-faint); }

        /* actual textboxes stay in the DOM (for postback) but hidden from view */
        .hidden-field {
            position: absolute;
            width: 1px; height: 1px;
            opacity: 0; overflow: hidden;
        }

        .cal-panel {
            display: none;
            margin-top: 10px;
            border: 1px solid var(--border);
            border-radius: var(--radius-s);
            background: var(--surface);
            padding: 16px;
        }

        .cal-panel.open { display: block; }

        .cal-head {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 12px;
        }

        .cal-head .month { font-size: 14px; font-weight: 600; }

        .cal-nav button {
            width: 26px; height: 26px; border-radius: 6px;
            border: 1px solid var(--border); background: var(--surface);
            color: var(--ink-soft); cursor: pointer;
        }

        .cal-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 4px;
        }

        .cal-dow {
            text-align: center; font-size: 11px; color: var(--ink-faint);
            padding-bottom: 4px; font-weight: 500;
        }

        .cal-day {
            aspect-ratio: 1;
            display: flex; align-items: center; justify-content: center;
            font-size: 12.5px; border-radius: 6px; cursor: pointer;
            color: var(--ink);
        }

        .cal-day.muted { color: var(--ink-faint); pointer-events: none; }
        .cal-day.weekend { background: var(--weekend); color: var(--ink-faint); }
        .cal-day.holiday { color: var(--rejected); pointer-events: none; }
        .cal-day.in-range { background: var(--primary-soft); color: var(--primary); }
        .cal-day.range-end { background: var(--primary); color: #fff; font-weight: 600; }

        .cal-foot {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 12px; padding-top: 12px; border-top: 1px solid var(--border);
            font-size: 12.5px; color: var(--ink-soft);
        }

        .cal-foot button {
            border: 0; background: var(--primary); color: #fff;
            padding: 7px 14px; border-radius: var(--radius-s);
            font-size: 12.5px; font-weight: 600; cursor: pointer;
        }


        /* =====================================================
           FORM
           ===================================================== */

        .form-label {
            font-size: 12.5px; font-weight: 600; color: var(--ink-soft);
            margin-bottom: 6px; display: block;
        }

        .required { color: var(--rejected); }

        .form-control, .form-select {
            border-radius: var(--radius-s);
            border: 1px solid var(--border);
            min-height: 40px;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 .2rem rgba(31,92,79,.12);
        }


        /* =====================================================
           EMPLOYEE INFO
           ===================================================== */

        .employee-info {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-s);
            padding: 16px;
        }

        .employee-info-row {
            display: flex; justify-content: space-between;
            padding: 7px 0; font-size: 13px;
            border-bottom: 1px solid #F0F1EE;
        }

        .employee-info-row:last-child { border-bottom: 0; }

        .employee-info-label { color: var(--ink-faint); }
        .employee-info-value { color: var(--ink); font-weight: 600; }


        /* =====================================================
           LEAVE BALANCE (gvLeaveBalance restyled as bars)
           ===================================================== */

        .leave-balance-grid,
        .leave-balance-grid tbody,
        .leave-balance-grid tr,
        .leave-balance-grid td {
            display: block;
            width: 100%;
            border: 0;
            padding: 0;
        }

        .bal-item { margin-bottom: 14px; }
        .bal-item:last-child { margin-bottom: 0; }

        .bal-top {
            display: flex; justify-content: space-between;
            font-size: 13px; margin-bottom: 6px;
        }

        .bal-top .name { font-weight: 500; }
        .bal-top .nums { color: var(--ink-faint); font-size: 12px; }
        .bal-top .nums b { color: var(--ink); font-weight: 600; }

        .bal-track {
            height: 6px; background: var(--weekend);
            border-radius: 999px; overflow: hidden;
        }

        .bal-fill { height: 100%; background: var(--primary); border-radius: 999px; }


        /* =====================================================
           REASON
           ===================================================== */

        .reason-box { min-height: 90px; resize: vertical; }


        /* =====================================================
           BUTTONS
           ===================================================== */

        .btn-save { background: var(--primary); color: #fff; border: 0; }
        .btn-save:hover { background: #17473D; color: #fff; }


        /* =====================================================
           REPORT GRID (gvLeaveReport)
           ===================================================== */

        .grid-wrap { overflow-x: auto; }

        .leave-grid { width: 100%; border-collapse: collapse; }

        .leave-grid th {
            background: var(--primary); color: #fff;
            padding: 10px; font-size: 12.5px; white-space: nowrap;
            text-align: left; font-weight: 500;
        }

        .leave-grid td {
            padding: 10px; border-bottom: 1px solid var(--border); font-size: 13px;
        }

        .leave-grid tr:hover td { background: #FAFBF9; }

        .status-pending  { color: var(--pending);  font-weight: 700; }
        .status-approved { color: var(--approved); font-weight: 700; }
        .status-rejected { color: var(--rejected); font-weight: 700; }


        /* =====================================================
           REPORT FILTER
           ===================================================== */

        .report-filter {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-s);
            padding: 16px;
        }

    </style>


    <div class="leave-page">

        <div class="leave-card">

            <!-- HEADER -->
            <div class="leave-header">
                
                <small>Apply for leave and view leave history</small>
            </div>

            <!-- TABS -->
            <div class="leave-tabs">
                <asp:LinkButton ID="lnkApplyLeave" runat="server" CssClass="leave-tab active" Font-Underline="false" OnClick="lnkApplyLeave_Click">
                    <i class="bi bi-pencil-square me-1"></i>Apply Leave
                </asp:LinkButton>
                <asp:LinkButton ID="lnkLeaveReport" runat="server" CssClass="leave-tab" OnClick="lnkLeaveReport_Click">
                    <i class="bi bi-list-ul me-1"></i>Leave Report
                </asp:LinkButton>
            </div>

            <!-- =================================================
                 APPLY LEAVE PANEL
                 ================================================= -->
            <asp:Panel ID="pnlApplyLeave" runat="server">

                <div class="p-4">

                    <div class="row g-4">

                        <!-- LEFT: leave type, dates, reason, actions -->
                        <div class="col-lg-7">

                            <div class="leave-section"><i class="bi bi-calendar-event me-2"></i>Leave Information</div>

                            <label class="form-label">Leave Type <span class="required">*</span></label>

                            <!-- Real control: still the value that posts back. Rendered visually as chips below. -->
                            <asp:DropDownList ID="ddlLeaveType" runat="server" CssClass="form-select ddl-source">
                            </asp:DropDownList>
                            <div id="ltChipRow" class="lt-chip-row"><!-- chips injected by JS from ddlLeaveType --></div>

                            <label class="form-label">Dates <span class="required">*</span></label>

                            <!-- Real controls stay in the DOM so codebehind's txtFromDate.Text / txtToDate.Text keep working -->
                            <asp:TextBox ID="txtFromDate" runat="server" CssClass="hidden-field" placeholder="dd-mm-yyyy"></asp:TextBox>
                            <asp:TextBox ID="txtToDate" runat="server" CssClass="hidden-field" placeholder="dd-mm-yyyy"></asp:TextBox>

                            <div id="dateTrigger" class="date-trigger">
                                <span id="dateTriggerLabel" class="ph">Select date range</span>
                                <i class="bi bi-calendar3"></i>
                            </div>

                            <div id="calPanel" class="cal-panel">
                                <div class="cal-head">
                                    <div class="cal-nav"><button type="button" id="calPrev">&#8249;</button></div>
                                    <div class="month" id="calMonthLabel"></div>
                                    <div class="cal-nav"><button type="button" id="calNext">&#8250;</button></div>
                                </div>
                                <div class="cal-grid" id="calGrid"></div>
                                <div class="cal-foot">
                                    <span id="calSummary">No dates selected</span>
                                    <button type="button" id="calDone">Done</button>
                                </div>
                            </div>

                            <div class="row g-3 mt-1">
                                <div class="col-md-4">
                                    <label class="form-label">Total Leave (Days)</label>
                                    <asp:TextBox ID="txtTotalLeave" runat="server" CssClass="form-control" Text="0" ReadOnly="true"></asp:TextBox>
                                </div>
                            </div>

                            <div class="leave-section mt-4"><i class="bi bi-chat-left-text me-2"></i>Leave Reason</div>

                            <label class="form-label">Reason <span class="required">*</span></label>
                            <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" CssClass="form-control reason-box" placeholder="Enter reason for leave..."></asp:TextBox>

                            <div class="d-flex gap-2 mt-4">
                                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-save px-4" OnClick="btnSave_Click" />
                                <asp:Button ID="btnSaveNew" runat="server" Text="Save & New" CssClass="btn btn-primary px-4" OnClick="btnSaveNew_Click" />
                                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary px-4" CausesValidation="false" OnClick="btnClear_Click" />
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-danger px-4" CausesValidation="false" OnClick="btnCancel_Click" />
                            </div>

                            <asp:Label ID="lblMessage" runat="server" CssClass="d-block mt-3"></asp:Label>

                        </div>

                        <!-- RIGHT: employee info + balance -->
                        <div class="col-lg-5">

                            <div class="leave-section"><i class="bi bi-person-badge me-2"></i>Employee Information</div>

                            <div class="employee-info mb-4">
                                <div class="employee-info-row">
                                    <div class="employee-info-label">Employee</div>
                                    <div class="employee-info-value"><asp:Label ID="lblEmployee" runat="server"></asp:Label></div>
                                </div>
                                <div class="employee-info-row">
                                    <div class="employee-info-label">Department</div>
                                    <div class="employee-info-value"><asp:Label ID="lblDepartment" runat="server"></asp:Label></div>
                                </div>
                                <div class="employee-info-row">
                                    <div class="employee-info-label">Designation</div>
                                    <div class="employee-info-value"><asp:Label ID="lblDesignation" runat="server"></asp:Label></div>
                                </div>
                                <div class="employee-info-row">
                                    <div class="employee-info-label">Joining Date</div>
                                    <div class="employee-info-value"><asp:Label ID="lblJoiningDate" runat="server"></asp:Label></div>
                                </div>
                            </div>

                            <div class="leave-section"><i class="bi bi-bar-chart me-2"></i>Leave Balance</div>

                            <div class="employee-info">
                                <asp:GridView ID="gvLeaveBalance" runat="server" AutoGenerateColumns="False"
                                    CssClass="leave-balance-grid" GridLines="None" ShowHeader="false">
                                    <Columns>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <div class="bal-item">
                                                    <div class="bal-top">
                                                        <span class="name"><%# Eval("LeaveTypeName") %></span>
                                                        <span class="nums"><b><%# Eval("Balance") %></b>/<%# Eval("Allocated") %></span>
                                                    </div>
                                                    <div class="bal-track">
                                                        <div class="bal-fill" style='width:<%# Math.Round((Convert.ToDouble(Eval("Balance")) / Math.Max(1, Convert.ToDouble(Eval("Allocated")))) * 100) %>%;'></div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>

                        </div>

                    </div>

                </div>

            </asp:Panel>


            <!-- =====================================================
                 LEAVE REPORT
                 ===================================================== -->
            <asp:Panel ID="pnlLeaveReport" runat="server" Visible="false">

                <div class="p-4">

                    <div class="leave-section"><i class="bi bi-funnel me-2"></i>Leave Report</div>

                    <div class="report-filter">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Employee</label>
                                <asp:DropDownList ID="ddlReportEmployee" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Leave Type</label>
                                <asp:DropDownList ID="ddlReportLeaveType" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">From Date</label>
                                <asp:TextBox ID="txtReportFromDate" runat="server" CssClass="form-control" placeholder="dd-mm-yyyy"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">To Date</label>
                                <asp:TextBox ID="txtReportToDate" runat="server" CssClass="form-control" placeholder="dd-mm-yyyy"></asp:TextBox>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Status</label>
                                <asp:DropDownList ID="ddlReportStatus" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="All" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                                    <asp:ListItem Text="Approved" Value="Approved"></asp:ListItem>
                                    <asp:ListItem Text="Rejected" Value="Rejected"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="d-flex gap-2 mt-3">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary px-4" OnClick="btnSearch_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-outline-secondary px-4" CausesValidation="false" OnClick="btnReset_Click" />
                        </div>
                    </div>

                    <div class="leave-card mt-4">
                        <div class="p-3 border-bottom">
                            <h5 class="mb-0" style="color:#1F5C4F;"><i class="bi bi-list-ul me-2"></i>Leave History</h5>
                        </div>

                        <div class="grid-wrap">
                            <asp:GridView ID="gvLeaveReport" runat="server" AutoGenerateColumns="False"
                                CssClass="leave-grid" GridLines="None" AllowPaging="True" PageSize="10"
                                EmptyDataText="No leave records found."
                                OnPageIndexChanging="gvLeaveReport_PageIndexChanging">
                                <Columns>
                                    <asp:BoundField DataField="SrNo" HeaderText="Sr." />
                                    <asp:BoundField DataField="EmployeeCode" HeaderText="Employee Code" />
                                    <asp:BoundField DataField="EmployeeName" HeaderText="Employee Name" />
                                    <asp:BoundField DataField="LeaveTypeName" HeaderText="Leave Type" />
                                    <asp:BoundField DataField="FromDate" HeaderText="From Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="ToDate" HeaderText="To Date" DataFormatString="{0:dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="TotalDays" HeaderText="Days" />
                                    <asp:BoundField DataField="Reason" HeaderText="Reason" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                                                <%# Eval("Status") %>
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>

                </div>

            </asp:Panel>

        </div>

    </div>


    <script>
        (function () {

            // ---- element refs (ClientID-safe: works inside content placeholders / master pages) ----
            var ddl        = document.getElementById('<%= ddlLeaveType.ClientID %>');
            var chipRow    = document.getElementById('ltChipRow');
            var fromField  = document.getElementById('<%= txtFromDate.ClientID %>');
            var toField    = document.getElementById('<%= txtToDate.ClientID %>');
            var totalField = document.getElementById('<%= txtTotalLeave.ClientID %>');

            var trigger      = document.getElementById('dateTrigger');
            var triggerLabel = document.getElementById('dateTriggerLabel');
            var panel         = document.getElementById('calPanel');
            var monthLabel    = document.getElementById('calMonthLabel');
            var grid          = document.getElementById('calGrid');
            var summary       = document.getElementById('calSummary');
            var prevBtn       = document.getElementById('calPrev');
            var nextBtn       = document.getElementById('calNext');
            var doneBtn       = document.getElementById('calDone');

            // ---- optional: populate this from the server (e.g. via a HiddenField bound to
            // your Holidays table) if you want holiday shading. Format: "yyyy-mm-dd".
            var HOLIDAYS = [];

            // =========================================================
            // 1) LEAVE TYPE CHIPS — built from the real <select>, so
            //    whatever the codebehind binds server-side just works.
            // =========================================================
            function buildChips() {
                if (!ddl) return;
                chipRow.innerHTML = '';
                Array.prototype.forEach.call(ddl.options, function (opt, idx) {
                    var chip = document.createElement('div');
                    chip.className = 'lt-chip' + (opt.selected ? ' sel' : '');
                    chip.innerHTML = '<span class="dot"></span>' + opt.text;
                    chip.addEventListener('click', function () {
                        ddl.selectedIndex = idx;
                        buildChips();
                    });
                    chipRow.appendChild(chip);
                });
            }
            buildChips();

            // =========================================================
            // 2) CALENDAR — writes dd-mm-yyyy into the real textboxes
            //    so codebehind's txtFromDate.Text / txtToDate.Text is
            //    unchanged, and computes weekday-only Total Leave (Days).
            // =========================================================
            var today = new Date();
            var viewYear = today.getFullYear();
            var viewMonth = today.getMonth();
            var rangeStart = null, rangeEnd = null;

            var MONTHS = ['January','February','March','April','May','June','July','August','September','October','November','December'];
            var DOW = ['S','M','T','W','T','F','S'];

            function pad(n) { return n < 10 ? '0' + n : '' + n; }
            function fmt(d) { return pad(d.getDate()) + '-' + pad(d.getMonth() + 1) + '-' + d.getFullYear(); }
            function iso(d) { return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()); }
            function isWeekend(d) { var w = d.getDay(); return w === 0 || w === 6; }
            function isHoliday(d) { return HOLIDAYS.indexOf(iso(d)) !== -1; }
            function sameDay(a, b) { return a && b && a.getFullYear()===b.getFullYear() && a.getMonth()===b.getMonth() && a.getDate()===b.getDate(); }

            function renderCalendar() {
                monthLabel.textContent = MONTHS[viewMonth] + ' ' + viewYear;
                grid.innerHTML = '';

                DOW.forEach(function (d) {
                    var el = document.createElement('div');
                    el.className = 'cal-dow';
                    el.textContent = d;
                    grid.appendChild(el);
                });

                var firstOfMonth = new Date(viewYear, viewMonth, 1);
                var startOffset = firstOfMonth.getDay();
                var daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();

                for (var i = 0; i < startOffset; i++) {
                    var pd = new Date(viewYear, viewMonth, i - startOffset + 1);
                    grid.appendChild(makeDayCell(pd, true));
                }
                for (var day = 1; day <= daysInMonth; day++) {
                    grid.appendChild(makeDayCell(new Date(viewYear, viewMonth, day), false));
                }
            }

            function makeDayCell(d, muted) {
                var cell = document.createElement('div');
                cell.className = 'cal-day' + (muted ? ' muted' : '');
                cell.textContent = d.getDate();

                if (!muted) {
                    if (isWeekend(d)) cell.classList.add('weekend');
                    if (isHoliday(d)) cell.classList.add('holiday');

                    if (rangeStart && !rangeEnd && sameDay(d, rangeStart)) cell.classList.add('range-end');
                    if (rangeStart && rangeEnd && d >= rangeStart && d <= rangeEnd) {
                        cell.classList.add(sameDay(d, rangeStart) || sameDay(d, rangeEnd) ? 'range-end' : 'in-range');
                    }

                    cell.addEventListener('click', function () { onDayClick(d); });
                }
                return cell;
            }

            function onDayClick(d) {
                if (!rangeStart || (rangeStart && rangeEnd)) {
                    rangeStart = d; rangeEnd = null;
                } else if (d < rangeStart) {
                    rangeEnd = rangeStart; rangeStart = d;
                } else {
                    rangeEnd = d;
                }
                renderCalendar();
                updateSummary();
            }

            function countWorkingDays(start, end) {
                if (!start) return 0;
                var e = end || start;
                var count = 0;
                var cur = new Date(start);
                while (cur <= e) {
                    if (!isWeekend(cur) && !isHoliday(cur)) count++;
                    cur.setDate(cur.getDate() + 1);
                }
                return count;
            }

            function updateSummary() {
                if (!rangeStart) {
                    summary.textContent = 'No dates selected';
                    triggerLabel.textContent = 'Select date range';
                    triggerLabel.classList.add('ph');
                    fromField.value = ''; toField.value = ''; totalField.value = '0';
                    return;
                }
                var end = rangeEnd || rangeStart;
                var days = countWorkingDays(rangeStart, end);

                fromField.value = fmt(rangeStart);
                toField.value = fmt(end);
                totalField.value = days;

                var label = fmt(rangeStart) + (rangeEnd ? '  \u2192  ' + fmt(end) : '');
                summary.textContent = days + (days === 1 ? ' working day' : ' working days');
                triggerLabel.textContent = label;
                triggerLabel.classList.remove('ph');
            }

            prevBtn.addEventListener('click', function () {
                viewMonth--; if (viewMonth < 0) { viewMonth = 11; viewYear--; }
                renderCalendar();
            });
            nextBtn.addEventListener('click', function () {
                viewMonth++; if (viewMonth > 11) { viewMonth = 0; viewYear++; }
                renderCalendar();
            });

            trigger.addEventListener('click', function () {
                panel.classList.toggle('open');
            });
            doneBtn.addEventListener('click', function () {
                panel.classList.remove('open');
            });
            document.addEventListener('click', function (e) {
                if (!panel.contains(e.target) && !trigger.contains(e.target)) {
                    panel.classList.remove('open');
                }
            });

            // if postback already has dates (e.g. validation failed and page re-rendered),
            // parse dd-mm-yyyy back into the picker so state survives a postback.
            (function restoreFromServerValue() {
                var v = fromField.value;
                if (v && v.indexOf('-') > -1) {
                    var p = v.split('-');
                    if (p.length === 3) {
                        rangeStart = new Date(p[2], p[1] - 1, p[0]);
                        viewYear = rangeStart.getFullYear();
                        viewMonth = rangeStart.getMonth();
                    }
                }
                var v2 = toField.value;
                if (v2 && v2.indexOf('-') > -1) {
                    var p2 = v2.split('-');
                    if (p2.length === 3) rangeEnd = new Date(p2[2], p2[1] - 1, p2[0]);
                }
                renderCalendar();
                updateSummary();
            })();

        })();
    </script>

</asp:Content>
