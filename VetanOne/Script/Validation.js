//============================
// PATHSHALA COMMON VALIDATION
//============================

// SweetAlert Toast

function ShowMessage(message, icon) {

    Swal.fire({

        toast: true,

        position: 'top-end',   // top-right

        icon: icon,

        title: message,

        showConfirmButton: false,

        timer: 1800,

        timerProgressBar: true,

        allowOutsideClick: false,

        allowEscapeKey: false,

        customClass: {

            popup: 'custom-popup'

        }

    });

}


// Shortcut

function $(id) {

    return document.getElementById(id);

}


// Empty Validation

function Validate(id, message) {

    var ctrl = $(id);

    if (ctrl.value.trim() == "") {

        ShowMessage(message, "warning");

        ctrl.focus();

        ctrl.style.border = "2px solid red";

        ctrl.style.background = "#fff5f5";

        setTimeout(function () {

            ctrl.style.border = "";

            ctrl.style.background = "";

        }, 2000);

        return false;

    }

    return true;

}


// Dropdown Validation

function ValidateDropDown(id, message) {

    var ctrl = $(id);

    if (ctrl.selectedIndex == 0) {

        ShowMessage(message, "warning");

        ctrl.focus();

        return false;

    }

    return true;

}


// Mobile Validation

function ValidateMobile(id) {

    var ctrl = $(id);

    var reg = /^[0-9][0-9]{9}$/;

    if (!reg.test(ctrl.value)) {

        ShowMessage("Invalid Mobile Number", "warning");

        ctrl.focus();

        return false;

    }

    return true;

}


// Email Validation

function ValidateEmail(id) {

    var ctrl = $(id);

    if (ctrl.value == "")
        return true;

    var reg = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Za-z]{2,}$/;

    if (!reg.test(ctrl.value)) {

        ShowMessage("Invalid Email Address", "warning");

        ctrl.focus();

        return false;

    }

    return true;

}


// Password Match

function ValidatePassword(idPassword,
    idConfirm) {

    if ($(idPassword).value !=
        $(idConfirm).value) {

        ShowMessage("Password does not match",
            "warning");

        $(idConfirm).focus();


        return false;

    }

    return true;

}


// Photo Validation

function ValidatePhoto(id, message) {

    if ($(id).value == "") {

        ShowMessage(message, "warning");

        return false;

    }

    return true;

}