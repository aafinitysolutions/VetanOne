<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="Login.aspx.vb" Inherits="VetanOne.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>VetanOne Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="Css/5.3.3bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <link href="Css/select2.min.css" rel="stylesheet" />
    <link href="Css/theme.css" rel="stylesheet" />

    <script src="Script/jquery.min.js"></script>
    <script src="Script/select2.min.js"></script>
</head>

<body class="login-body">

    <form id="form1" runat="server" defaultbutton="btnLogin">

        <div class="login-shell">

            <!-- ============ brand panel (echoes the sidebar) ============ -->
            <aside class="login-aside">

                <div class="la-brand">
                    <div class="la-mark"><img src="Logo/Logo.png" alt="" /></div>
                    <span class="la-name">Vetan One</span>
                </div>

                <div class="la-copy">
                    <h1 class="la-headline">People, payroll and performance in one place.</h1>
                    <p>Employees, leave, attendance and salary processing, managed from a single workspace.</p>
                </div>

                <div class="la-tags">
                    <span><i class="bi bi-people"></i>People</span>
                    <span><i class="bi bi-cash-stack"></i>Payroll</span>
                    <span><i class="bi bi-graph-up-arrow"></i>Performance</span>
                </div>

            </aside>

            <!-- ============ sign-in form ============ -->
            <main class="login-main">

                <div class="login-brand-mobile">
                    <div class="la-mark"><img src="Logo/Logo.png" alt="" /></div>
                    <span class="la-name">Vetan One</span>
                </div>

                <h2 class="login-title">Welcome back</h2>
                <p class="login-sub">Sign in to your workspace.</p>

                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert-v1 alert-v1-danger mb-v1-4" />

                <div class="form-group-v1">
                    <label class="form-label-v1" for="<%= ddlCompany.ClientID %>">Company name</label>
                    <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-select-v1 select2-v1" AppendDataBoundItems="true">
                        <asp:ListItem Text="Select company" Value="" />
                        <%-- bind companies in code-behind --%>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ddlCompany" InitialValue=""
                        ValidationGroup="login" Display="Dynamic" CssClass="field-error-v1"
                        ErrorMessage="Select your company." />
                </div>

                <div class="form-group-v1">
                    <label class="form-label-v1" for="<%= txtUserId.ClientID %>">User ID</label>
                    <div class="input-affix-v1 has-icon">
                        <i class="bi bi-person affix"></i>
                        <asp:TextBox ID="txtUserId" runat="server" CssClass="form-control-v1"
                            placeholder="name@company.com" autocomplete="username" />
                    </div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUserId"
                        ValidationGroup="login" Display="Dynamic" CssClass="field-error-v1"
                        ErrorMessage="Enter your user ID." />
                </div>

                <div class="form-group-v1">
                    <label class="form-label-v1" for="<%= txtPassword.ClientID %>">Password</label>
                    <div class="input-affix-v1 has-icon has-btn">
                        <i class="bi bi-lock affix"></i>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control-v1"
                            placeholder="Enter your password" autocomplete="current-password" />
                        <button type="button" class="affix-btn" id="togglePwd" title="Show or hide password" aria-label="Show or hide password">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="caps-hint d-none" id="capsHint"><i class="bi bi-exclamation-triangle"></i> Caps Lock is on</div>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPassword"
                        ValidationGroup="login" Display="Dynamic" CssClass="field-error-v1"
                        ErrorMessage="Enter your password." />
                </div>

                <div class="login-row">
                    <label class="switch-v1">
                        <asp:CheckBox ID="chkRemember" runat="server" />
                        <span>Remember me</span>
                    </label>
                    <a href="ForgotPassword.aspx">Forgot password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Log in" ValidationGroup="login"
                    CssClass="btn btn-v1-primary btn-login"
                    OnClientClick="return beginLogin();" OnClick="btnLogin_Click" />

                <div class="login-foot">&copy; 2026 V-Wave Technologies</div>

            </main>

        </div>

    </form>

    <script>
        document.addEventListener('DOMContentLoaded', function () {

            /* Select2 is optional polish: the page works the same without it */
            if (window.jQuery && jQuery.fn && jQuery.fn.select2) {
                jQuery('.select2-v1').select2({ width: '100%', minimumResultsForSearch: 8 });
            }

            var pwd = document.getElementById('<%= txtPassword.ClientID %>');
            var toggle = document.getElementById('togglePwd');
            var caps = document.getElementById('capsHint');

            toggle.addEventListener('click', function () {
                var hidden = pwd.type === 'password';
                pwd.type = hidden ? 'text' : 'password';
                var icon = toggle.querySelector('i');
                icon.className = hidden ? 'bi bi-eye-slash' : 'bi bi-eye';
            });

            function checkCaps(e) {
                var on = e.getModifierState && e.getModifierState('CapsLock');
                caps.classList.toggle('d-none', !on);
            }
            pwd.addEventListener('keydown', checkCaps);
            pwd.addEventListener('keyup', checkCaps);
        });

        function beginLogin() {
            if (typeof Page_ClientValidate === 'function' && !Page_ClientValidate('login')) return false;
            var btn = document.getElementById('<%= btnLogin.ClientID %>');
            setTimeout(function () { btn.value = 'Signing in...'; btn.classList.add('is-loading'); }, 0);
            return true;
        }
    </script>

</body>
</html>
    