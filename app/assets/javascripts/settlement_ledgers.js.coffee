$ ->
  $('.datepicker').datepicker({language: 'ja'})
  $('#conditionTab a:first').tab('show')
  $('a[data-toggle="tab"]').on('shown.bs.tab', (e) ->
    $.ajax
      url: "/settlement_ledgers?target=" + e.target.toString().match(/#.+/gi)[0].replace("#", "")
      type: "GET"
      dataType: "script"
      success: (ajax) ->
        eval(ajax)
  )
