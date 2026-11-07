/* ==========================================================================
   ui.js — toast / confirm / loading helpers on top of SweetAlert2.
   Code-behind calls these via ScriptManager.RegisterStartupScript, e.g.:
     ScriptManager.RegisterStartupScript(this, GetType(), "toast",
       "ui.toast('success','Employee saved successfully.');", true);
   ========================================================================== */
(function (window) {
  "use strict";

  var ui = {};

  /**
   * ui.toast(type, message)
   * type: 'success' | 'warning' | 'error' | 'info'
   * Success/info auto-dismiss after 4s. Errors stay until closed.
   */
  ui.toast = function (type, message) {
    var icon = type === "error" ? "error" : type;
    var isError = type === "error" || type === "warning";
    Swal.fire({
      toast: true,
      position: "top-end",
      icon: icon,
      title: message,
      showConfirmButton: false,
      timer: isError ? undefined : 4000,
      timerProgressBar: !isError,
      showCloseButton: isError
    });
  };

  /**
   * ui.confirm(options) -> Promise<boolean>
   * options: { title, text, confirmText, danger }
   * Use for destructive/irreversible actions only.
   */
  ui.confirm = function (options) {
    options = options || {};
    return Swal.fire({
      title: options.title || "Are you sure?",
      text: options.text || "This action cannot be undone.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: options.confirmText || "Yes, continue",
      cancelButtonText: "Cancel",
      reverseButtons: true,
      confirmButtonColor: options.danger === false ? undefined : "#B91C1C",
      focusCancel: true
    }).then(function (result) {
      return result.isConfirmed;
    });
  };

  /** Wraps a submit button in a spinner + disables it while an async action runs. */
  ui.withLoading = function (buttonEl, promiseFactory) {
    if (!buttonEl) return promiseFactory();
    buttonEl.classList.add("is-loading");
    buttonEl.disabled = true;
    return promiseFactory().finally(function () {
      buttonEl.classList.remove("is-loading");
      buttonEl.disabled = false;
    });
  };

  /** Thin top progress bar, driven from app.js around partial postbacks. */
  ui.progressStart = function () {
    var bar = document.querySelector(".hr-progress-bar");
    if (!bar) return;
    bar.classList.remove("done");
    // force reflow so the transition restarts
    void bar.offsetWidth;
    bar.classList.add("active");
  };
  ui.progressDone = function () {
    var bar = document.querySelector(".hr-progress-bar");
    if (!bar) return;
    bar.classList.remove("active");
    bar.classList.add("done");
    setTimeout(function () { bar.classList.remove("done"); }, 200);
  };

  window.ui = ui;
})(window);
