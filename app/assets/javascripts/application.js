// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require cable
//= require i18n
//= require i18n/translations
//= require i18n.js
//= require bootstrap-sprockets
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ja.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require ckeditor/init
//= require ckeditor/config
//= require datepicker
//= require highcharts
//= require highcharts/highcharts-more
//= require admin/dark-unica
//= require jquery.slimscroll
//= require filter-data
//= require filter-box
//= require blank_option_filter
//= require table_config
//= require hight_light_table
//= require notify
//= require admin/role_permission
//= require admin/evaluation
//= require admin/note
//= require jquery-ui/dialog
//= require jquery-ui/sortable
//= require jquery-ui/effect-highlight
//= require jquery-ui/slider
//= require admin/update_order_course_subject
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require jquery.dataTables.columnFilter
//= require datatable
//= require subject
//= require evaluation
//= require role
//= require user
//= require evaluation_template
//= require rank
//= require university
//= require admin/assign_user
//= require jquery.quicksearch
//= require chat
//= require bindWithDelay
//= require pagination
//= require admin/location
//= require admin/user
//= require admin/dashboard_chart
//= require admin/user_profile
//= require admin/user_subject
//= require jquery.countdown
//= require admin/subject
//= require exam
//= require question
//= require statistic
//= require spectrum

$(document).on("turbolinks:load ajaxComplete", function() {
  $(".alert").delay(3000).fadeOut();
  $("#error_explanation").delay(3000).slideUp();
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().parent().hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(document).on("turbolinks:load", function() {
  $(".ckeditor-field").each(function() {
    CKEDITOR.replace($(this).attr("id"));
  });

  $(".sidebar-toggle").click(function() {
    $("#body-admin").toggleClass("sidebar-collapse")
  });

  $(".treeview").click(function() {
    $(this).toggleClass("active");
    $(".treeview-menu").toggleClass("menu-open");
  });

  if ($(".evaluation-active").length > 0) {
    $("#evaluations-header").addClass("active");
  }

  if ($(".systems-active").length > 0) {
    $("#systems-header").addClass("active");
  }

  if ($(".shedules-active").length > 0) {
    $("#schedule-header").addClass("active");
  }

  $("#slimScrollDiv").slimScroll();
  $("#slimscroll_admin").slimScroll();
});

function isDatepicker(element) {
  var arr_element = ["prev", "next", "datepicker-switch", "old day", "new day",
    "active day", "year old", "year new", "dow", "day", "month", "today", "clear",
    "datepicker datepicker-dropdown dropdown-menu datepicker-orient-left datepicker-orient-top",
    "year active", "year", "month active"];
  return arr_element.indexOf(element.attr("class")) !== -1
}

$(document).on('turbolinks:load', '.open-select', function(e, xhr, opts) {
  var $filterDom = $('.' + $(this).attr('data-name'));

  if($filterDom.length > 0) {
    xhr.abort();
    console.log('cancel ajax');
  }
});

function resetOrder() {
  var stt = 0;
  var list_record = $('#list-records').find('.trow .stt:visible').not('.header').not('.sum');
  $.each(list_record, function(){
    stt++;
    $(this).html(stt);
  });
}

$(document).on('ready, turbolinks:load', function() {
  $(document).ajaxStart(function() {
    $('#loading').show();
  });
  $(document).ajaxStop(function() {
    $('#loading').hide();
  });
  $(document).ajaxError(function() {
    $('#loading').hide();
  });
});

function totalTraineeValue() {
  $.each($('.fixedTable-header .trainee-by-month'), function(key, value) {
    var total_trainee_in_month = 0
    var total_trainee_in_month_filter = 0;

    $.each($('.fixedTable-body .total-trainees-month-' + $(value).data('month')), function(index, element) {
      if(!$(element).hasClass('total')){
        total_trainee_in_month += parseInt($(element).data("total-trainees"));
      }
    });

    $.each($('.fixedTable-body .trow:visible .total-trainees-month-' + $(value).data('month')), function(index, element) {
      if(!$(element).hasClass('total')){
        total_trainee_in_month_filter += parseInt($(element).data("total-trainees"));
      }
    });

    percent = total_trainee_in_month_filter / total_trainee_in_month * 100;
    if (percent == 100 || total_trainee_in_month == 0) {
      $('#fixed-bottom-body .total-trainees-month-' + $(value).data('month')).text(total_trainee_in_month_filter.toLocaleString());
    } else {
      $('#fixed-bottom-body .total-trainees-month-' + $(value).data('month')).text(total_trainee_in_month_filter.toLocaleString() + ' - ' + Math.round(percent).toFixed(2) + '%');
    }
  });
}



$(function() {

  var $formLogin = $('#login-form');
  var $formLost = $('#lost-form');
  var $formRegister = $('#register-form');
  var $divForms = $('#div-forms');
  var $modalAnimateTime = 300;
  var $msgAnimateTime = 150;
  var $msgShowTime = 2000;

  $("form").submit(function () {
    switch(this.id) {
      case "login-form":
        var $lg_username=$('#login_username').val();
        var $lg_password=$('#login_password').val();
        if ($lg_username == "ERROR") {
          msgChange($('#div-login-msg'), $('#icon-login-msg'), $('#text-login-msg'), "error", "glyphicon-remove", "Login error");
        } else {
          msgChange($('#div-login-msg'), $('#icon-login-msg'), $('#text-login-msg'), "success", "glyphicon-ok", "Login OK");
        }
        return false;
        break;
      case "lost-form":
        var $ls_email=$('#lost_email').val();
        if ($ls_email == "ERROR") {
          msgChange($('#div-lost-msg'), $('#icon-lost-msg'), $('#text-lost-msg'), "error", "glyphicon-remove", "Send error");
        } else {
          msgChange($('#div-lost-msg'), $('#icon-lost-msg'), $('#text-lost-msg'), "success", "glyphicon-ok", "Send OK");
        }
        return false;
        break;
      case "register-form":
        var $rg_username=$('#register_username').val();
        var $rg_email=$('#register_email').val();
        var $rg_password=$('#register_password').val();
        if ($rg_username == "ERROR") {
          msgChange($('#div-register-msg'), $('#icon-register-msg'), $('#text-register-msg'), "error", "glyphicon-remove", "Register error");
        } else {
          msgChange($('#div-register-msg'), $('#icon-register-msg'), $('#text-register-msg'), "success", "glyphicon-ok", "Register OK");
        }
        return false;
        break;
      default:
        return false;
    }
    return false;
  });

  $('#login_register_btn').click( function () { modalAnimate($formLogin, $formRegister) });
  $('#register_login_btn').click( function () { modalAnimate($formRegister, $formLogin); });
  $('#login_lost_btn').click( function () { modalAnimate($formLogin, $formLost); });
  $('#lost_login_btn').click( function () { modalAnimate($formLost, $formLogin); });
  $('#lost_register_btn').click( function () { modalAnimate($formLost, $formRegister); });
  $('#register_lost_btn').click( function () { modalAnimate($formRegister, $formLost); });

  function modalAnimate ($oldForm, $newForm) {
    var $oldH = $oldForm.height();
    var $newH = $newForm.height();
    $divForms.css("height",$oldH);
    $oldForm.fadeToggle($modalAnimateTime, function(){
      $divForms.animate({height: $newH}, $modalAnimateTime, function(){
        $newForm.fadeToggle($modalAnimateTime);
      });
    });
  }

  function msgFade ($msgId, $msgText) {
    $msgId.fadeOut($msgAnimateTime, function() {
      $(this).text($msgText).fadeIn($msgAnimateTime);
    });
  }

  function msgChange($divTag, $iconTag, $textTag, $divClass, $iconClass, $msgText) {
    var $msgOld = $divTag.text();
    msgFade($textTag, $msgText);
    $divTag.addClass($divClass);
    $iconTag.removeClass("glyphicon-chevron-right");
    $iconTag.addClass($iconClass + " " + $divClass);
    setTimeout(function() {
      msgFade($textTag, $msgOld);
      $divTag.removeClass($divClass);
      $iconTag.addClass("glyphicon-chevron-right");
      $iconTag.removeClass($iconClass + " " + $divClass);
    }, $msgShowTime);
  }
});
