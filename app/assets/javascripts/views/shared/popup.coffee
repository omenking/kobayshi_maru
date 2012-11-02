class App.Views.Shared.Popup extends Backbone.View
  events:
    'click'      : 'pop'
    'click .save': 'save'
  initialize:->
  render:->
    data =
      klass : @className
    html = @template 'shared/popup', data
    $('body .popup_wrap').remove()
    $('body').prepend html
    @popup = $('body .popup_wrap .popup .popup_content')
    $('body .popup_wrap .actions .close').click @close
    #$('body .popup_wrap').click @remove
  pop:(e)->
    e.preventDefault() if e
    @render()
  remove:(e)=>
    if $(e.target).hasClass 'pop'
      $('body .popup_wrap').remove()
  close:()=>
    $('body .popup_wrap').remove()
  save:->
    console.log 'saving'
