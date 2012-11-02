#= require views/shared/popup.coffee
class App.Views.Games.LeftPopup extends App.Views.Shared.Popup
  className: 'left_popup'
  render:->
    super()
    html = @template 'games/left', @options.data
    @popup.html html
