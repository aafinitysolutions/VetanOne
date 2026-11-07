<%@ Page Title="Leave Services" Language="VB" MasterPageFile="~/Site1.master" AutoEventWireup="false" CodeBehind="LeaveServices.aspx.vb" Inherits="VetanOne.LeaveServices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
    /* Safety net: the same rules live in theme-additions.css. They keep the views and
       wizard steps working even if that file has not been pasted into theme.css yet. */
    .hub-view { display: none; }
    .hub-view.active { display: block; }
    .step-pane { display: none; }
    .step-pane.active { display: block; }
</style>

<div class="leave-page page-container">

    <%-- your login is not linked to an employee record --%>
    <asp:Panel ID="pnlNoEmployee" runat="server" Visible="false">
        <div class="alert-v1 alert-v1-danger">
            Your login is not linked to an employee record, so leave services are not available.
            Ask HR to link your user to an employee.
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlLeave" runat="server">

    <%-- remembers the open view across postbacks --%>
    <asp:HiddenField ID="hfView" runat="server" Value="hub" />


    <!-- =====================================================
         HUB
         ===================================================== -->
    <div class="hub-view active" id="view-hub">

        <h2 class="hub-title">What do you want to do?</h2>

        <div class="hub-grid">

            <button type="button" class="hub-tile" data-view="apply">
                <span class="hub-ico"><i class="bi bi-calendar2-plus"></i></span>
                <span class="hub-name">Apply for leave</span>
                <span class="hub-sub">Guided 3-step request</span>
            </button>

            <button type="button" class="hub-tile" data-view="requests">
                <span class="hub-ico"><i class="bi bi-list-check"></i></span>
                <span class="hub-name">My requests</span>
                <span class="hub-sub">Track status &amp; history</span>
            </button>

            <%-- shown only to Admin / HR and to people who have direct reports --%>
            <asp:PlaceHolder ID="phApprovalsTile" runat="server">
                <button type="button" class="hub-tile" data-view="approvals">
                    <span class="hub-ico"><i class="bi bi-clipboard-check"></i></span>
                    <span class="hub-name">Approvals</span>
                    <span class="hub-sub"><asp:Literal ID="litPending" runat="server" /></span>
                </button>
            </asp:PlaceHolder>

            <button type="button" class="hub-tile" data-view="calendar">
                <span class="hub-ico"><i class="bi bi-people"></i></span>
                <span class="hub-name">Team calendar</span>
                <span class="hub-sub">Who's out this week</span>
            </button>

        </div>

        <section class="card-v1">
            <div class="hub-bal-title">Your balance</div>
            <asp:Repeater ID="rptBalance" runat="server">
                <ItemTemplate>
                    <div class="bal-row"><span><%#: Eval("LeaveName") %></span><strong><%# Num(Eval("Available")) %> / <%# Num(Eval("Allotted")) %></strong></div>
                    <div class="bar-track-v1"><div class="bar-fill-v1 brand" style="width:<%# Pct(Eval("Available"), Eval("Allotted")) %>%"></div></div>
                </ItemTemplate>
            </asp:Repeater>
            <div class="bal-hint">Balance is shown after keeping aside days on your pending requests.</div>
        </section>

    </div>


    <!-- =====================================================
         APPLY FOR LEAVE  (3 steps)
         ===================================================== -->
    <div class="hub-view" id="view-apply">

        <div class="view-head">
            <button type="button" class="btn-v1-icon btn-back" data-view="hub" title="Back" aria-label="Back"><i class="bi bi-arrow-left"></i></button>
            <h2>Apply for leave</h2>
        </div>

        <div class="row">
            <div class="col-xl-8">

                <div class="stepper-v1">
                    <div class="step-v1 active" data-step="1"><span class="num">1</span><span class="lbl-txt">Leave &amp; dates</span></div>
                    <div class="step-v1" data-step="2"><span class="num">2</span><span class="lbl-txt">Details</span></div>
                    <div class="step-v1" data-step="3"><span class="num">3</span><span class="lbl-txt">Review &amp; submit</span></div>
                </div>

                <section class="card-v1">

                    <!-- ---- step 1 ---- -->
                    <div class="step-pane active" data-step="1">
                        <div class="row g-3">

                            <div class="col-12">
                                <label class="form-label-v1" for="<%= ddlLeaveType.ClientID %>">Leave type<span class="required">*</span></label>
                                <asp:DropDownList ID="ddlLeaveType" runat="server" CssClass="form-select-v1 select2-v1" />
                                <div class="bal-hint" id="balHint"></div>
                            </div>

                            <div class="col-sm-6">
                                <label class="form-label-v1" for="<%= txtFrom.ClientID %>">From<span class="required">*</span></label>
                                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" CssClass="form-control-v1" />
                            </div>

                            <div class="col-sm-6">
                                <label class="form-label-v1" for="<%= txtTo.ClientID %>">To<span class="required">*</span></label>
                                <asp:TextBox ID="txtTo" runat="server" TextMode="Date" CssClass="form-control-v1" />
                            </div>

                            <div class="col-sm-6">
                                <label class="form-label-v1">Half day</label>
                                <div class="flag-tile">
                                    <span class="flag-name">Apply for half a day</span>
                                    <asp:CheckBox ID="chkHalf" runat="server" CssClass="switch-v1" ToolTip="Half day" />
                                </div>
                            </div>

                            <div class="col-sm-6 d-none" id="halfSessionBox">
                                <label class="form-label-v1" for="<%= ddlHalf.ClientID %>">Session</label>
                                <asp:DropDownList ID="ddlHalf" runat="server" CssClass="form-select-v1">
                                    <asp:ListItem Text="First half" Value="FH" />
                                    <asp:ListItem Text="Second half" Value="SH" />
                                </asp:DropDownList>
                            </div>

                            <div class="col-sm-6" id="daysBox">
                                <label class="form-label-v1" for="<%= txtDays.ClientID %>">Total days</label>
                                <asp:TextBox ID="txtDays" runat="server" CssClass="form-control-v1" ReadOnly="true" />
                            </div>

                        </div>
                    </div>

                    <!-- ---- step 2 ---- -->
                    <div class="step-pane" data-step="2">
                        <div class="row g-3">

                            <div class="col-12">
                                <label class="form-label-v1" for="<%= txtReason.ClientID %>">Reason<span class="required">*</span></label>
                                <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control-v1"
                                    placeholder="Briefly say why you need this leave" />
                            </div>

                            <div class="col-sm-6">
                                <label class="form-label-v1" for="<%= txtContact.ClientID %>">Contact number during leave</label>
                                <asp:TextBox ID="txtContact" runat="server" CssClass="form-control-v1" MaxLength="10" inputmode="numeric" />
                            </div>

                            <div class="col-sm-6">
                                <label class="form-label-v1" for="<%= ddlHandover.ClientID %>">Work handover to</label>
                                <asp:DropDownList ID="ddlHandover" runat="server" CssClass="form-select-v1 select2-v1" />
                            </div>

                            <div class="col-12">
                                <label class="form-label-v1" for="<%= fuAttach.ClientID %>">Attachment (optional, up to 5 MB)</label>
                                <asp:FileUpload ID="fuAttach" runat="server" CssClass="form-control-v1 file-v1" />
                            </div>

                        </div>
                    </div>

                    <!-- ---- step 3 ---- -->
                    <div class="step-pane" data-step="3">
                        <dl class="review-list" id="reviewList"></dl>
                    </div>

                    <div class="wizard-foot">
                        <button type="button" class="btn btn-v1-secondary" id="btnPrev"><i class="bi bi-arrow-left"></i> Back</button>
                        <button type="button" class="btn btn-v1-primary" id="btnNext">Next <i class="bi bi-arrow-right"></i></button>
                        <asp:LinkButton ID="btnSubmit" runat="server" CssClass="btn btn-v1-primary d-none" CausesValidation="false"
                            OnClientClick="return finalCheck();" OnClick="btnSubmit_Click"><i class="bi bi-send"></i> Submit request</asp:LinkButton>
                    </div>

                </section>
            </div>
        </div>
    </div>


    <!-- =====================================================
         MY REQUESTS
         ===================================================== -->
    <div class="hub-view" id="view-requests">

        <div class="view-head">
            <button type="button" class="btn-v1-icon btn-back" data-view="hub" title="Back" aria-label="Back"><i class="bi bi-arrow-left"></i></button>
            <h2>My requests</h2>
        </div>

        <div class="tabs-v1 mb-v1-4">
            <button type="button" class="tab-v1 active" data-filter="all">All</button>
            <button type="button" class="tab-v1" data-filter="pending">Pending</button>
            <button type="button" class="tab-v1" data-filter="approved">Approved</button>
            <button type="button" class="tab-v1" data-filter="rejected">Rejected</button>
        </div>

        <div class="table-responsive">
            <table class="data-grid-v1" id="tblRequests">
                <thead>
                    <tr>
                        <th>Applied on</th>
                        <th>Leave type</th>
                        <th>Period</th>
                        <th class="num">Days</th>
                        <th>Status</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptRequests" runat="server">
                        <ItemTemplate>
                            <tr data-status="<%# Eval("StatusKey") %>">
                                <td><%# Convert.ToDateTime(Eval("AppliedOn")).ToString("dd MMM yyyy") %></td>
                                <td><%#: Eval("LeaveName") %></td>
                                <td><%# Period(Eval("FromDate"), Eval("ToDate"), Eval("IsHalfDay")) %></td>
                                <td class="num"><%# Num(Eval("TotalDays")) %></td>
                                <td><span class="pill-v1 <%# PillClass(Eval("StatusKey")) %>"><span class="dot"></span><%#: Eval("StatusText") %></span></td>
                                <td>
                                    <%# ActionButton(Eval("StatusKey"), Eval("RequestId"), Eval("Reason"), Eval("DecisionRemarks")) %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <tr id="rowEmpty" class="d-none">
                        <td colspan="6"><div class="grid-empty-v1">No requests here yet.</div></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <asp:HiddenField ID="hfCancelId" runat="server" />
        <asp:Button ID="btnCancelReq" runat="server" CssClass="d-none" CausesValidation="false" OnClick="btnCancelReq_Click" />
    </div>


    <!-- =====================================================
         APPROVALS
         ===================================================== -->
    <div class="hub-view" id="view-approvals">

        <div class="view-head">
            <button type="button" class="btn-v1-icon btn-back" data-view="hub" title="Back" aria-label="Back"><i class="bi bi-arrow-left"></i></button>
            <h2>Approvals</h2>
        </div>

        <asp:Repeater ID="rptApprovals" runat="server">
            <ItemTemplate>
                <div class="approval-item" data-id="<%# Eval("RequestId") %>">
                    <span class="avatar-v1 avatar-v1-lg"><%#: Initials(Eval("EmployeeName")) %></span>
                    <div class="ap-main">
                        <div class="ap-name"><%#: Eval("EmployeeName") %></div>
                        <div class="ap-dept"><%#: Eval("EmployeeCode") %> &middot; <%#: Eval("DepartmentName") %></div>
                        <div class="ap-meta"><%#: Eval("LeaveName") %> &middot; <%# Period(Eval("FromDate"), Eval("ToDate"), Eval("IsHalfDay")) %> &middot; <%# Num(Eval("TotalDays")) %> day(s)</div>
                        <div class="ap-reason"><%#: Eval("Reason") %></div>
                    </div>
                    <div class="btn-row">
                        <button type="button" class="btn btn-v1-danger btn-v1-sm" data-decide="reject">Reject</button>
                        <button type="button" class="btn btn-v1-primary btn-v1-sm" data-decide="approve">Approve</button>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoApprovals" runat="server" Visible="false">
            <div class="card-v1"><div class="grid-empty-v1">Nothing is waiting for your approval.</div></div>
        </asp:Panel>

        <%-- decision plumbing: script fills these, then clicks btnDecision --%>
        <asp:HiddenField ID="hfReqId" runat="server" />
        <asp:HiddenField ID="hfAction" runat="server" />
        <asp:HiddenField ID="hfRemarks" runat="server" />
        <asp:Button ID="btnDecision" runat="server" CssClass="d-none" CausesValidation="false" OnClick="btnDecision_Click" />

    </div>


    <!-- =====================================================
         TEAM CALENDAR
         ===================================================== -->
    <div class="hub-view" id="view-calendar">

        <div class="view-head">
            <button type="button" class="btn-v1-icon btn-back" data-view="hub" title="Back" aria-label="Back"><i class="bi bi-arrow-left"></i></button>
            <h2>Who's out this week</h2>
        </div>

        <asp:Literal ID="litWeek" runat="server" />

    </div>

    </asp:Panel>
</div>


<script>
    document.addEventListener('DOMContentLoaded', function () {

        /* No jQuery needed: everything below is plain JavaScript. */

        if (!document.getElementById('view-hub')) return;      // panel hidden (no employee record)

        function byId(id) { return document.getElementById(id); }
        function each(list, fn) { Array.prototype.forEach.call(list, fn); }
        function el(sel) { return document.querySelector(sel); }

        /* Select2 is optional polish: used only if it was loaded */
        if (window.jQuery && jQuery.fn && jQuery.fn.select2) {
            jQuery('.select2-v1').select2({ width: '100%', minimumResultsForSearch: 8 });
        }

        var f = {
            type: byId('<%= ddlLeaveType.ClientID %>'),
            from: byId('<%= txtFrom.ClientID %>'),
            to: byId('<%= txtTo.ClientID %>'),
            half: byId('<%= chkHalf.ClientID %>'),
            session: byId('<%= ddlHalf.ClientID %>'),
            days: byId('<%= txtDays.ClientID %>'),
            reason: byId('<%= txtReason.ClientID %>'),
            contact: byId('<%= txtContact.ClientID %>'),
            handover: byId('<%= ddlHandover.ClientID %>'),
            view: byId('<%= hfView.ClientID %>')
        };

        /* balances come from the database (keyed by leave type id) */
        var BAL = <%= BalanceJson %>;


        /* =====================  VIEW SWITCHING  ===================== */

        function showView(name) {
            if (!byId('view-' + name)) name = 'hub';
            each(document.querySelectorAll('.hub-view'), function (v) {
                v.classList.toggle('active', v.id === 'view-' + name);
            });
            f.view.value = name;
            window.scrollTo(0, 0);
        }

        document.addEventListener('click', function (e) {
            var t = e.target.closest('[data-view]');
            if (!t) return;
            e.preventDefault();
            showView(t.getAttribute('data-view'));
        });

        showView(f.view.value || 'hub');


        /* =====================  APPLY WIZARD  ===================== */

        var step = 1;

        function fmt(v) {
            return new Date(v + 'T00:00:00').toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
        }

        function wrapOf(control) {
            var n = control;
            while (n && !(n.classList && (n.classList.contains('col-12') || n.classList.contains('col-sm-6')))) n = n.parentNode;
            return n || control.parentNode;
        }

        function setError(control, msg) {
            var wrap = wrapOf(control);
            var old = wrap.querySelector('.js-err');
            if (old) old.parentNode.removeChild(old);
            control.classList.toggle('is-invalid-v1', !!msg);
            if (msg) {
                var s = document.createElement('span');
                s.className = 'field-error-v1 js-err';
                s.textContent = msg;
                wrap.appendChild(s);
            }
            return !msg;
        }

        function calcDays() {
            var from = f.from.value, to = f.to.value;
            var sameDay = from && to && from === to;

            f.half.disabled = !sameDay;
            if (!sameDay) f.half.checked = false;
            byId('halfSessionBox').classList.toggle('d-none', !f.half.checked);

            if (!from || !to) { f.days.value = ''; updateHint(); return; }
            var d = Math.round((new Date(to) - new Date(from)) / 864e5) + 1;
            if (d < 1) { f.days.value = ''; updateHint(); return; }
            f.days.value = f.half.checked ? 0.5 : d;
            updateHint();
        }

        function updateHint() {
            var b = BAL[f.type.value], h = byId('balHint'), d = parseFloat(f.days.value);
            if (!b) { h.textContent = ''; h.classList.remove('over'); return; }
            h.textContent = 'Available: ' + b.left + ' of ' + b.total + ' days';
            h.classList.toggle('over', !isNaN(d) && d > b.left);
        }

        function validateStep(n) {
            var ok = true;
            if (n === 1) {
                ok = setError(f.type, f.type.value ? '' : 'Select a leave type.') && ok;
                ok = setError(f.from, f.from.value ? '' : 'Choose a start date.') && ok;

                var toMsg = '';
                if (!f.to.value) toMsg = 'Choose an end date.';
                else if (f.from.value && f.to.value < f.from.value) toMsg = 'End date cannot be before the start date.';
                ok = setError(f.to, toMsg) && ok;

                var b = BAL[f.type.value], d = parseFloat(f.days.value);
                if (ok && b && d > b.left) ok = setError(f.to, 'This is more than your available balance (' + b.left + ' days).') && ok;
            }
            if (n === 2) {
                ok = setError(f.reason, f.reason.value.trim().length >= 5 ? '' : 'Add a short reason (at least 5 characters).') && ok;
            }
            return ok;
        }

        function goStep(n) {
            step = n;
            each(document.querySelectorAll('.step-pane'), function (p) { p.classList.toggle('active', parseInt(p.getAttribute('data-step'), 10) === n); });
            each(document.querySelectorAll('.step-v1'), function (s) {
                var i = parseInt(s.getAttribute('data-step'), 10);
                s.classList.toggle('active', i === n);
                s.classList.toggle('done', i < n);
                s.querySelector('.num').innerHTML = i < n ? '<i class="bi bi-check-lg"></i>' : i;
            });
            byId('btnPrev').classList.toggle('invisible', n === 1);
            byId('btnNext').classList.toggle('d-none', n === 3);
            byId('<%= btnSubmit.ClientID %>').classList.toggle('d-none', n !== 3);
            if (n === 3) buildReview();
        }

        function optionText(sel) {
            var o = sel.options[sel.selectedIndex];
            return o && o.value ? o.text : '';
        }

        function buildReview() {
            var b = BAL[f.type.value], d = parseFloat(f.days.value);
            var period = fmt(f.from.value) + (f.to.value !== f.from.value ? ' \u2013 ' + fmt(f.to.value) : '');
            if (f.half.checked) period += ' (' + optionText(f.session) + ')';

            var rows = [
                ['Leave type', b ? b.name : ''],
                ['Period', period],
                ['Total days', f.days.value],
                ['Balance after', b ? (b.left - d) + ' of ' + b.total + ' days' : ''],
                ['Reason', f.reason.value.trim()],
                ['Contact', f.contact.value.trim() || '\u2013'],
                ['Work handover', optionText(f.handover) || '\u2013']
            ];

            var dl = byId('reviewList');
            dl.innerHTML = '';
            rows.forEach(function (r) {
                var dt = document.createElement('dt'), dd = document.createElement('dd');
                dt.textContent = r[0]; dd.textContent = r[1];
                dl.appendChild(dt); dl.appendChild(dd);
            });
        }

        byId('btnNext').addEventListener('click', function () { if (validateStep(step)) goStep(step + 1); });
        byId('btnPrev').addEventListener('click', function () { if (step > 1) goStep(step - 1); });

        f.type.addEventListener('change', function () { setError(f.type, ''); updateHint(); });
        f.from.addEventListener('change', function () { f.to.min = f.from.value; setError(f.from, ''); calcDays(); });
        f.to.addEventListener('change', function () { setError(f.to, ''); calcDays(); });
        f.half.addEventListener('change', calcDays);
        f.reason.addEventListener('input', function () { setError(f.reason, ''); });

        /* Select2 fires a jQuery change event: mirror it so the plain listeners above still run */
        if (window.jQuery) { jQuery(f.type).on('change', function () { setError(f.type, ''); updateHint(); }); }

        window.finalCheck = function () {
            if (!validateStep(1)) { goStep(1); return false; }
            if (!validateStep(2)) { goStep(2); return false; }
            return true;
        };

        calcDays();
        goStep(1);


        /* =====================  MY REQUESTS  ===================== */

        function applyFilter(name) {
            var shown = 0;
            each(document.querySelectorAll('#tblRequests tbody tr[data-status]'), function (tr) {
                var show = name === 'all' || tr.getAttribute('data-status') === name;
                tr.classList.toggle('d-none', !show);
                if (show) shown++;
            });
            byId('rowEmpty').classList.toggle('d-none', shown > 0);
        }

        each(document.querySelectorAll('[data-filter]'), function (b) {
            b.addEventListener('click', function () {
                each(document.querySelectorAll('[data-filter]'), function (x) { x.classList.remove('active'); });
                b.classList.add('active');
                applyFilter(b.getAttribute('data-filter'));
            });
        });
        applyFilter('all');

        document.addEventListener('click', function (e) {
            var cancel = e.target.closest('.js-cancel');
            if (cancel) {
                var id = cancel.getAttribute('data-id');
                var go = function () {
                    byId('<%= hfCancelId.ClientID %>').value = id;
                    byId('<%= btnCancelReq.ClientID %>').click();
                };
                if (window.Swal) {
                    Swal.fire({ title: 'Cancel this request?', text: 'A cancelled request cannot be restored.', icon: 'question',
                        showCancelButton: true, confirmButtonText: 'Cancel request', cancelButtonText: 'Keep it', confirmButtonColor: '#B8493F' })
                        .then(function (r) { if (r.isConfirmed) go(); });
                } else if (confirm('Cancel this request?')) { go(); }
                return;
            }

            var view = e.target.closest('.js-view');
            if (view) {
                var reason = view.getAttribute('data-reason') || '';
                var remarks = view.getAttribute('data-remarks') || '';
                var text = 'Reason: ' + reason + (remarks ? '\n\nDecision remarks: ' + remarks : '');
                if (window.Swal) Swal.fire({ title: 'Request details', text: text, icon: 'info', confirmButtonColor: '#1F5C4F' });
                else alert(text);
            }
        });


        /* =====================  APPROVALS  ===================== */

        function sendDecision(id, action, remarks) {
            byId('<%= hfReqId.ClientID %>').value = id;
            byId('<%= hfAction.ClientID %>').value = action;
            byId('<%= hfRemarks.ClientID %>').value = remarks || '';
            byId('<%= btnDecision.ClientID %>').click();
        }

        document.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-decide]');
            if (!btn) return;

            var item = btn.closest('.approval-item');
            var id = item.getAttribute('data-id'), action = btn.getAttribute('data-decide');
            var who = item.querySelector('.ap-name').textContent;
            var meta = item.querySelector('.ap-meta').textContent;

            if (!window.Swal) {                       // minimal fallback
                if (action === 'approve') { if (confirm('Approve ' + who + '?')) sendDecision(id, 'approve', ''); }
                else { var why = prompt('Reason for rejection:'); if (why && why.trim()) sendDecision(id, 'reject', why.trim()); }
                return;
            }

            if (action === 'approve') {
                Swal.fire({ title: 'Approve this request?', text: who + ' \u2013 ' + meta, icon: 'question',
                    showCancelButton: true, confirmButtonText: 'Approve', confirmButtonColor: '#1F5C4F' })
                    .then(function (r) { if (r.isConfirmed) sendDecision(id, 'approve', ''); });
            } else {
                Swal.fire({ title: 'Reject this request?', text: who, input: 'textarea', inputPlaceholder: 'Reason for rejection',
                    showCancelButton: true, confirmButtonText: 'Reject', confirmButtonColor: '#B8493F',
                    inputValidator: function (v) { if (!v || !v.trim()) return 'Enter a reason so the employee knows why.'; } })
                    .then(function (r) { if (r.isConfirmed) sendDecision(id, 'reject', r.value.trim()); });
            }
        });

    });
</script>

</asp:Content>
