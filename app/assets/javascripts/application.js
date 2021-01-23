// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require jquery.jpostal
//= require tag-it
//= require_tree.

// トップへスクロール
$(function () {
  $('#go-top').on('click', function () {
    $('body, html').animate({
      scrollTop: 0
    }, 800);
    return false;
  });
});


// 「ジャンルから探す」へスクロール
$(function () {
  let position = $('#genre-search').offset().top;

  $('#go-genre-search').on('click', function () {
    $('body, html').animate({
      scrollTop: position
    }, 800);
    return false;
  });
});


// 「利用シーンから探す」へスクロール
$(function () {
  let position = $('#scene-search').offset().top;

  $('#go-scene-search').on('click', function () {
    $('body, html').animate({
      scrollTop: position
    }, 800);
    return false;
  });
});


// 「都道府県から探す」へスクロール
$(function () {
  let position = $('#prefecture-search').offset().top;

  $('#go-prefecture-search').on('click', function () {
    $('body, html').animate({
      scrollTop: position
    }, 800);
    return false;
  });
});


// 「現在地から探す」へスクロール
$(function () {
  let position = $('#location-search').offset().top;

  $('#go-location-search').on('click', function () {
    $('body, html').animate({
      scrollTop: position
    }, 800);
    return false;
  });
});
