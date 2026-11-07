/* ==========================================================================
   app.js — inits everything by CSS class (not ID), and re-runs after every
   UpdatePanel partial postback. This is the #1 Web Forms + Select2/flatpickr
   bug source, so every page must load this after content, and every custom
   control must init through initUI(), never inline in the .aspx.
   ========================================================================== */
(function (window, $) {
  "use strict";

  function initUI(root) {
    root = root || document;

    // Select2
    if (window.jQuery && $.fn.select2) {
      $(root).find(".js-select2").each(function () {
        var $el = $(this);
        if ($el.data("select2")) return; // already initialized
        $el.select2({
          width: "100%",
          placeholder: $el.data("placeholder") || "Select...",
          allowClear: !!$el.data("allow-clear"),
          dropdownParent: $el.closest(".modal, .offcanvas").length
            ? $el.closest(".modal, .offcanvas")
            : $(document.body)
        });
      });
    }

    // flatpickr — single date
    if (window.flatpickr) {
      root.querySelectorAll(".js-date:not(.flatpickr-input)").forEach(function (el) {
        flatpickr(el, { dateFormat: "d-M-Y", altInput: false });
      });
      // flatpickr — date range
      root.querySelectorAll(".js-daterange:not(.flatpickr-input)").forEach(function (el) {
        flatpickr(el, { mode: "range", dateFormat: "d-M-Y" });
      });
    }

    // Bootstrap tooltips (icon buttons, truncated text)
    if (window.bootstrap) {
      root.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (el) {
        if (!bootstrap.Tooltip.getInstance(el)) new bootstrap.Tooltip(el);
      });
    }

    // Mirror ASP.NET validator failure onto Select2 containers
    root.querySelectorAll("select.is-invalid + .select2-container").forEach(function (el) {
      el.classList.add("is-invalid");
    });
  }

  // Sidebar collapse — remembered across pages
  function initSidebar() {
    var sidebar = document.querySelector(".hr-sidebar");
    var btn = document.querySelector(".hr-sidebar__collapse-btn");
    if (!sidebar || !btn) return;

    if (localStorage.getItem("hr-sidebar-collapsed") === "1") {
      sidebar.classList.add("collapsed");
    }
    btn.addEventListener("click", function () {
      sidebar.classList.toggle("collapsed");
      localStorage.setItem("hr-sidebar-collapsed", sidebar.classList.contains("collapsed") ? "1" : "0");
    });

    // Accordion nav groups — one open at a time, active page's group auto-opens
    document.querySelectorAll(".hr-nav-group > .hr-nav-item").forEach(function (item) {
      item.addEventListener("click", function () {
        var group = item.parentElement;
        var wasOpen = group.classList.contains("open");
        document.querySelectorAll(".hr-nav-group.open").forEach(function (g) { g.classList.remove("open"); });
        if (!wasOpen) group.classList.add("open");
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    initUI(document);
    initSidebar();
  });

  // Re-init after every UpdatePanel partial postback, and drive the
  // top progress bar around the request.
  if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    prm.add_beginRequest(function () {
      if (window.ui) ui.progressStart();
    });
    prm.add_endRequest(function () {
      initUI(document);
      if (window.ui) ui.progressDone();
    });
  }

  window.initUI = initUI;
})(window, window.jQuery);
