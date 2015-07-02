$ ->
  $('.datepicker').datepicker({language: 'ja'})
  
  if (document.cookie.search('all')) != -1
    open_tab = 'all'
  else
    open_tab = 'not-completed'

  if open_tab == 'not-completed'
    $.ajax
      url: "/settlement_ledgers"
      type: "GET"
      dataType: "script"
      success: (ajax) ->
        eval(ajax)
    $("a[href = '#not-completed']").tab('show')
  else if window.location.toString().search('target=all') == -1
    $.ajax
      url: "/settlement_ledgers?target=all"
      type: "GET"
      dataType: "script"
      success: (ajax) ->
        eval(ajax)
    $("a[href = '#all']").tab('show')
  else
    $("a[href = '#all']").tab('show')
    
#  $('#conditionTab a:first').tab('show')
    
  $('a[data-toggle="tab"]').on('shown.bs.tab', (e) ->
    document.cookie = e.target.toString().match(/#.+/gi)[0].replace("#", "")
    $.ajax
      url: "/settlement_ledgers?target=" + e.target.toString().match(/#.+/gi)[0].replace("#", "")
      type: "GET"
      dataType: "script"
      success: (ajax) ->
        eval(ajax)
  )
