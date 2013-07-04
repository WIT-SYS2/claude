# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('.datepicker').datepicker({language: 'ja'})
  $('#conditionTab a:first').tab('show')
  $('a[data-toggle="tab"]').on('shown', (e) ->
    $.ajax
      url: "/settlement_ledgers?target=" + e.target.toString().match(/#.+/gi)[0].replace("#", "")
      type: "GET"
      dataType: "script"
      success: (ajax) ->
        eval(ajax)
  )
