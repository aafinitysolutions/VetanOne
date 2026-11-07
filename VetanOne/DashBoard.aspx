<%@ Page Title="Dashboard" Language="VB" MasterPageFile="~/Site1.master" AutoEventWireup="false" CodeBehind="Dashboard.aspx.vb" Inherits="VetanOne.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
     <link href="Css/dashboard.css" rel="stylesheet" />

<div class="page-container">

    <%-- All figures on this page are hardcoded sample data (as of 30 Sep 2026). --%>

    <!-- ===================== GREETING + QUICK ACTIONS ===================== -->
    <div class="dash-greet">
        <div>
            <p class="dash-greet-text"><%: Greeting %></p>
            <div class="dash-greet-sub">Here is where the workforce stands today.</div>
        </div>
        <div class="quick-actions">
            <a class="qa-chip" href="EmployeeMaster.aspx"><i class="bi bi-person-plus"></i>Add employee</a>
            <a class="qa-chip" href="AttendanceUpload.aspx"><i class="bi bi-cloud-arrow-up"></i>Upload attendance</a>
            <a class="qa-chip" href="LeaveServices.aspx"><i class="bi bi-calendar2-plus"></i>Apply leave</a>
            <a class="qa-chip" href="SalaryProcess.aspx"><i class="bi bi-calculator"></i>Process salary</a>
        </div>
    </div>


    <!-- ===================== ROW 1: attendance today + payroll cycle ===================== -->
    <div class="row g-3 mb-3">

        <div class="col-xl-8">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Attendance today</h3>
                        <div class="dash-card-sub">Wednesday, 30 Sep 2026</div>
                    </div>
                    <a class="dash-link" href="AttendanceUpload.aspx">Attendance upload</a>
                </div>

                <div class="att-top">
                    <div class="att-number">1,092<small>of 1,248 employees present</small></div>
                    <span class="pill-v1 pill-v1-approved"><span class="dot"></span>87.5% present</span>
                </div>

                <%-- segment widths are data-driven: set from data-w by the page script --%>
                <div class="seg-bar" role="img" aria-label="Present 87.5%, on leave 3.7%, absent 3.0%, weekly off 5.8%">
                    <span class="seg-present" data-w="87.5"></span>
                    <span class="seg-leave" data-w="3.7"></span>
                    <span class="seg-absent" data-w="3.0"></span>
                    <span class="seg-off" data-w="5.8"></span>
                </div>

                <div class="seg-legend">
                    <div><b>1,092</b><i class="lg-dot seg-present"></i>Present</div>
                    <div><b>46</b><i class="lg-dot seg-leave"></i>On leave</div>
                    <div><b>38</b><i class="lg-dot seg-absent"></i>Absent</div>
                    <div><b>72</b><i class="lg-dot seg-off"></i>Weekly off</div>
                </div>

                <div class="shift-list">
                    <div class="shift-row">
                        <div class="shift-name">Shift A<small>06:00 &ndash; 14:00</small></div>
                        <div class="bar-track-v1"><div class="bar-fill-v1" data-w="90.7"></div></div>
                        <div class="shift-count"><b>372</b> / 410</div>
                    </div>
                    <div class="shift-row">
                        <div class="shift-name">Shift B<small>14:00 &ndash; 22:00</small></div>
                        <div class="bar-track-v1"><div class="bar-fill-v1" data-w="89.7"></div></div>
                        <div class="shift-count"><b>341</b> / 380</div>
                    </div>
                    <div class="shift-row">
                        <div class="shift-name">Shift C<small>22:00 &ndash; 06:00</small></div>
                        <div class="bar-track-v1"><div class="bar-fill-v1" data-w="88.4"></div></div>
                        <div class="shift-count"><b>168</b> / 190</div>
                    </div>
                    <div class="shift-row">
                        <div class="shift-name">General<small>09:30 &ndash; 18:00</small></div>
                        <div class="bar-track-v1"><div class="bar-fill-v1 warn" data-w="78.7"></div></div>
                        <div class="shift-count"><b>211</b> / 268</div>
                    </div>
                </div>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="pay-card">
                <div>
                    <h3>September 2026 payroll</h3>
                    <div class="pay-sub">Salary credit planned for 05 Oct</div>
                </div>

                <div>
                    <div class="pay-pct"><b>68%</b><span>846 of 1,248 salaries processed</span></div>
                    <div class="pay-bar"><span data-w="68"></span></div>
                </div>

                <ul class="pay-steps">
                    <li class="done"><span class="ps-ico"><i class="bi bi-check-lg"></i></span>
                        <div><span class="ps-name">Attendance locked</span><span class="ps-meta">Closed 28 Sep</span></div></li>
                    <li class="now"><span class="ps-ico"></span>
                        <div><span class="ps-name">Salary processing</span><span class="ps-meta">In progress, 402 employees left</span></div></li>
                    <li><span class="ps-ico"></span>
                        <div><span class="ps-name">Statutory files</span><span class="ps-meta">PF, ESIC and PT after processing</span></div></li>
                    <li><span class="ps-ico"></span>
                        <div><span class="ps-name">Bank advice</span><span class="ps-meta">Due 04 Oct</span></div></li>
                </ul>

                <div class="pay-foot">
                    <small>Last cycle closed on time</small>
                    <a class="btn-mint" href="SalaryProcess.aspx"><i class="bi bi-arrow-right-circle"></i>Open salary process</a>
                </div>
            </section>
        </div>

    </div>


    <!-- ===================== ROW 2: KPI tiles ===================== -->
    <div class="row g-3 mb-3">

        <div class="col-6 col-xl-3">
            <div class="kpi-tile">
                <div class="kpi-icon"><i class="bi bi-people"></i></div>
                <div class="kpi-label">Total employees</div>
                <div class="kpi-value">1,248</div>
                <div class="kpi-sub"><span class="kpi-delta up">+18</span> joined this month, 6 left</div>
            </div>
        </div>

        <div class="col-6 col-xl-3">
            <div class="kpi-tile warn">
                <div class="kpi-icon"><i class="bi bi-clipboard-check"></i></div>
                <div class="kpi-label">Pending approvals</div>
                <div class="kpi-value">12</div>
                <div class="kpi-sub">7 leave, 3 advance, 2 other</div>
            </div>
        </div>

        <div class="col-6 col-xl-3">
            <div class="kpi-tile accent">
                <div class="kpi-icon"><i class="bi bi-alarm"></i></div>
                <div class="kpi-label">Late arrivals today</div>
                <div class="kpi-value">37</div>
                <div class="kpi-sub"><span class="kpi-delta up">15 fewer</span> than yesterday</div>
            </div>
        </div>

        <div class="col-6 col-xl-3">
            <div class="kpi-tile">
                <div class="kpi-icon"><i class="bi bi-clock-history"></i></div>
                <div class="kpi-label">Overtime this week</div>
                <div class="kpi-value">412 h</div>
                <div class="kpi-sub"><span class="kpi-delta down">+9%</span> vs last week</div>
            </div>
        </div>

    </div>


    <!-- ===================== ROW 3: trend + workforce mix ===================== -->
    <div class="row g-3 mb-3">

        <div class="col-xl-8">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Attendance, last 14 days</h3>
                        <div class="dash-card-sub">Present as a share of the workforce. Sundays are weekly off.</div>
                    </div>
                    <a class="dash-link" href="PayrollRegister.aspx">Reports</a>
                </div>
                <div id="trendChart"></div>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Workforce mix</h3>
                        <div class="dash-card-sub">By employee type</div>
                    </div>
                </div>
                <div class="donut-wrap">
                    <div id="mixChart"></div>
                    <ul class="mix-legend" id="mixLegend"></ul>
                </div>
            </section>
        </div>

    </div>


    <!-- ===================== ROW 4: departments / approvals / statutory ===================== -->
    <div class="row g-3 mb-3">

        <div class="col-lg-6 col-xl-4">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Headcount by department</h3>
                        <div class="dash-card-sub">Top six departments</div>
                    </div>
                </div>

                <div class="dept-row"><span>Production</span><div class="bar-track-v1"><div class="bar-fill-v1" data-w="100"></div></div><span class="dept-count">462</span></div>
                <div class="dept-row"><span>Maintenance</span><div class="bar-track-v1"><div class="bar-fill-v1" data-w="25.5"></div></div><span class="dept-count">118</span></div>
                <div class="dept-row"><span>Quality</span><div class="bar-track-v1"><div class="bar-fill-v1" data-w="22.5"></div></div><span class="dept-count">104</span></div>
                <div class="dept-row"><span>Stores</span><div class="bar-track-v1"><div class="bar-fill-v1" data-w="19.9"></div></div><span class="dept-count">92</span></div>
                <div class="dept-row"><span>Dispatch</span><div class="bar-track-v1"><div class="bar-fill-v1" data-w="16.5"></div></div><span class="dept-count">76</span></div>
                <div class="dept-row"><span>HR &amp; Admin</span><div class="bar-track-v1"><div class="bar-fill-v1" data-w="12.6"></div></div><span class="dept-count">58</span></div>
            </section>
        </div>

        <div class="col-lg-6 col-xl-4">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Waiting for your approval</h3>
                        <div class="dash-card-sub">Oldest first</div>
                    </div>
                    <a class="dash-link" href="LeaveApproval.aspx">View all 12</a>
                </div>

                <ul class="dash-list">
                    <li>
                        <span class="avatar-v1">RK</span>
                        <div class="dl-main"><div class="dl-title">Ravi Kumar</div><div class="dl-sub">Casual leave, 30 Sep &ndash; 01 Oct (2 days)</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-pending"><span class="dot"></span>Leave</span></div>
                    </li>
                    <li>
                        <span class="avatar-v1">AS</span>
                        <div class="dl-main"><div class="dl-title">Anita Sharma</div><div class="dl-sub">Salary advance, &#8377;15,000</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-neutral"><span class="dot"></span>Advance</span></div>
                    </li>
                    <li>
                        <span class="avatar-v1">SR</span>
                        <div class="dl-main"><div class="dl-title">Suresh Reddy</div><div class="dl-sub">Earned leave, 12 &ndash; 16 Oct (5 days)</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-pending"><span class="dot"></span>Leave</span></div>
                    </li>
                    <li>
                        <span class="avatar-v1">MI</span>
                        <div class="dl-main"><div class="dl-title">Mohammed Irfan</div><div class="dl-sub">Salary advance, &#8377;8,000</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-neutral"><span class="dot"></span>Advance</span></div>
                    </li>
                </ul>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Statutory due dates</h3>
                        <div class="dash-card-sub">For September wages</div>
                    </div>
                </div>

                <ul class="dash-list">
                    <li>
                        <span class="date-tile"><b>07</b><span>Oct</span></span>
                        <div class="dl-main"><div class="dl-title">TDS on salary</div><div class="dl-sub">Deposit for September</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-pending"><span class="dot"></span>7 days</span></div>
                    </li>
                    <li>
                        <span class="date-tile"><b>10</b><span>Oct</span></span>
                        <div class="dl-main"><div class="dl-title">Professional tax</div><div class="dl-sub">Monthly return</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-neutral"><span class="dot"></span>10 days</span></div>
                    </li>
                    <li>
                        <span class="date-tile"><b>15</b><span>Oct</span></span>
                        <div class="dl-main"><div class="dl-title">PF and ESIC</div><div class="dl-sub">ECR and contribution challan</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-neutral"><span class="dot"></span>15 days</span></div>
                    </li>
                    <li>
                        <span class="date-tile"><b>31</b><span>Dec</span></span>
                        <div class="dl-main"><div class="dl-title">Labour welfare fund</div><div class="dl-sub">Half-yearly contribution</div></div>
                        <div class="dl-end"><span class="pill-v1 pill-v1-neutral"><span class="dot"></span>92 days</span></div>
                    </li>
                </ul>
                <p class="dash-card-note">Sample dates. Confirm state-wise dates before relying on them.</p>
            </section>
        </div>

    </div>


    <!-- ===================== ROW 5: new joiners + coming up ===================== -->
    <div class="row g-3">

        <div class="col-xl-8">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">New joiners this month</h3>
                        <div class="dash-card-sub">18 joined in September</div>
                    </div>
                    <a class="dash-link" href="EmployeeMaster.aspx">Add employee</a>
                </div>

                <div class="table-responsive">
                    <table class="data-grid-v1 data-grid-v1-compact">
                        <thead>
                            <tr><th>Employee</th><th>Department</th><th>Designation</th><th>Joined</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><div class="flex-v1 flex-v1-gap-2"><span class="avatar-v1 avatar-v1-sm">KP</span><div><div class="dl-title">Kiran Patel</div><div class="dl-sub">E1249</div></div></div></td>
                                <td>Production</td><td>Machine operator</td><td>29 Sep 2026</td>
                                <td><span class="pill-v1 pill-v1-pending"><span class="dot"></span>Documents pending</span></td>
                            </tr>
                            <tr>
                                <td><div class="flex-v1 flex-v1-gap-2"><span class="avatar-v1 avatar-v1-sm">DN</span><div><div class="dl-title">Divya Nair</div><div class="dl-sub">E1248</div></div></div></td>
                                <td>Quality</td><td>QC inspector</td><td>22 Sep 2026</td>
                                <td><span class="pill-v1 pill-v1-approved"><span class="dot"></span>Active</span></td>
                            </tr>
                            <tr>
                                <td><div class="flex-v1 flex-v1-gap-2"><span class="avatar-v1 avatar-v1-sm">HB</span><div><div class="dl-title">Harish Babu</div><div class="dl-sub">E1247</div></div></div></td>
                                <td>Maintenance</td><td>Electrician</td><td>15 Sep 2026</td>
                                <td><span class="pill-v1 pill-v1-approved"><span class="dot"></span>Active</span></td>
                            </tr>
                            <tr>
                                <td><div class="flex-v1 flex-v1-gap-2"><span class="avatar-v1 avatar-v1-sm">SF</span><div><div class="dl-title">Sana Fatima</div><div class="dl-sub">E1246</div></div></div></td>
                                <td>HR &amp; Admin</td><td>HR executive</td><td>08 Sep 2026</td>
                                <td><span class="pill-v1 pill-v1-approved"><span class="dot"></span>Active</span></td>
                            </tr>
                            <tr>
                                <td><div class="flex-v1 flex-v1-gap-2"><span class="avatar-v1 avatar-v1-sm">GR</span><div><div class="dl-title">Gopal Rao</div><div class="dl-sub">E1245</div></div></div></td>
                                <td>Stores</td><td>Store keeper</td><td>01 Sep 2026</td>
                                <td><span class="pill-v1 pill-v1-neutral"><span class="dot"></span>On probation</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>

        <div class="col-xl-4">
            <section class="card-v1 h-100">
                <div class="dash-card-head">
                    <div>
                        <h3 class="dash-card-title">Coming up</h3>
                        <div class="dash-card-sub">Next three weeks</div>
                    </div>
                    <a class="dash-link" href="HolidayMaster.aspx">Holidays</a>
                </div>

                <div class="dash-subhead">Holidays</div>
                <ul class="dash-list">
                    <li>
                        <span class="date-tile"><b>02</b><span>Oct</span></span>
                        <div class="dl-main"><div class="dl-title">Gandhi Jayanti</div><div class="dl-sub">Friday, plant closed</div></div>
                    </li>
                    <li>
                        <span class="date-tile"><b>20</b><span>Oct</span></span>
                        <div class="dl-main"><div class="dl-title">Vijayadashami</div><div class="dl-sub">Tuesday, plant closed</div></div>
                    </li>
                </ul>

                <div class="dash-subhead">Probation ending</div>
                <ul class="dash-list">
                    <li>
                        <span class="avatar-v1">NM</span>
                        <div class="dl-main"><div class="dl-title">Nikhil Menon</div><div class="dl-sub">Quality, confirmation due 05 Oct</div></div>
                    </li>
                    <li>
                        <span class="avatar-v1">PY</span>
                        <div class="dl-main"><div class="dl-title">Pooja Yadav</div><div class="dl-sub">Dispatch, confirmation due 12 Oct</div></div>
                    </li>
                </ul>
            </section>
        </div>

    </div>

</div>


<script>
    (function () {

        /* ---------------------------------------------------------------
           Hardcoded sample data. Replace with values from the server later
           (e.g. emit these two objects from code-behind as JSON).
           --------------------------------------------------------------- */
        var TREND = {
            days:  [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30],
            wk:    ['Th', 'Fr', 'Sa', 'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su', 'Mo', 'Tu', 'We'],
            pct:   [88.6, 89.4, 85.1, 14.2, 90.3, 91.0, 89.8, 88.9, 90.6, 86.2, 13.8, 89.1, 88.2, 87.5],
            off:   [3, 10]                       // indexes of Sundays
        };

        var MIX = [
            { name: 'Permanent',  value: 812 },
            { name: 'Contract',   value: 296 },
            { name: 'Trainee',    value: 64 },
            { name: 'Daily wage', value: 76 }
        ];


        /* ---------- bars/segments whose width comes from data-w ---------- */
        document.querySelectorAll('[data-w]').forEach(function (n) { n.style.width = n.getAttribute('data-w') + '%'; });


        /* ---------- helpers ---------- */
        var NS = 'http://www.w3.org/2000/svg';
        function node(tag, attrs, text) {
            var n = document.createElementNS(NS, tag);
            for (var k in attrs) n.setAttribute(k, attrs[k]);
            if (text != null) n.textContent = text;
            return n;
        }


        /* ---------- attendance trend (bar chart) ---------- */
        (function () {
            var W = 700, H = 240, L = 34, R = 692, T = 14, B = 196;
            var plotW = R - L, plotH = B - T, n = TREND.pct.length;
            var step = plotW / n, bw = step * 0.56;
            var svg = node('svg', { viewBox: '0 0 ' + W + ' ' + H, 'class': 'chart-svg', role: 'img',
                                    'aria-label': 'Daily attendance percentage for the last 14 days' });

            [0, 25, 50, 75, 100].forEach(function (g) {
                var y = B - (g / 100) * plotH;
                svg.appendChild(node('line', { x1: L, x2: R, y1: y, y2: y, 'class': 'gl' }));
                svg.appendChild(node('text', { x: L - 8, y: y + 4, 'text-anchor': 'end', 'class': 'ax' }, g + '%'));
            });

            TREND.pct.forEach(function (v, i) {
                var isToday = i === n - 1;
                var isOff = TREND.off.indexOf(i) > -1;
                var h = (v / 100) * plotH;
                var x = L + i * step + (step - bw) / 2;
                var y = B - h;

                var r = node('rect', { x: x, y: y, width: bw, height: h, rx: 4,
                                       'class': 'bar' + (isOff ? ' off' : '') + (isToday ? ' today' : '') });
                r.appendChild(node('title', {}, TREND.days[i] + ' Sep: ' + v + '% present' + (isOff ? ' (weekly off)' : '')));
                svg.appendChild(r);

                var cx = x + bw / 2;
                svg.appendChild(node('text', { x: cx, y: B + 16, 'text-anchor': 'middle', 'class': 'ax' + (isToday ? ' ax-strong' : '') }, TREND.days[i]));
                svg.appendChild(node('text', { x: cx, y: B + 30, 'text-anchor': 'middle', 'class': 'ax' }, TREND.wk[i]));
                if (isToday) svg.appendChild(node('text', { x: cx, y: y - 6, 'text-anchor': 'middle', 'class': 'ax ax-strong' }, v + '%'));
            });

            document.getElementById('trendChart').appendChild(svg);
        })();


        /* ---------- workforce mix (donut) ---------- */
        (function () {
            var total = MIX.reduce(function (s, m) { return s + m.value; }, 0);
            var r = 54, C = 2 * Math.PI * r, gap = 3, acc = 0;

            var svg = node('svg', { viewBox: '0 0 160 160', role: 'img', 'aria-label': 'Workforce split by employee type' });
            svg.appendChild(node('circle', { cx: 80, cy: 80, r: r, 'class': 'dn-track' }));

            var g = node('g', { transform: 'rotate(-90 80 80)' });
            MIX.forEach(function (m, i) {
                var len = (m.value / total) * C;
                var seg = node('circle', {
                    cx: 80, cy: 80, r: r, 'class': 'dn-seg dn-' + i,
                    'stroke-dasharray': Math.max(len - gap, 0) + ' ' + C,
                    'stroke-dashoffset': -acc
                });
                seg.appendChild(node('title', {}, m.name + ': ' + m.value));
                g.appendChild(seg);
                acc += len;
            });
            svg.appendChild(g);
            svg.appendChild(node('text', { x: 80, y: 82, 'text-anchor': 'middle', 'class': 'donut-total' }, total.toLocaleString('en-IN')));
            svg.appendChild(node('text', { x: 80, y: 99, 'text-anchor': 'middle', 'class': 'donut-cap' }, 'employees'));
            document.getElementById('mixChart').appendChild(svg);

            var ul = document.getElementById('mixLegend');
            MIX.forEach(function (m, i) {
                var li = document.createElement('li');
                li.innerHTML = '<i class="lg-dot lg-' + i + '"></i><span>' + m.name + '</span><b>' +
                               m.value.toLocaleString('en-IN') + '</b>';
                ul.appendChild(li);
            });
        })();

    })();
</script>

</asp:Content>
