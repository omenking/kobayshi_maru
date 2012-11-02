#= require views/shared/popup.coffee
class App.Views.Games.EndPopup extends App.Views.Shared.Popup
  className: 'end_popup'
  render:->
    super()
    html = @template 'games/end', @options.data
    @popup.html html
