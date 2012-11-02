#= require views/shared/popup.coffee
class App.Views.Games.ChallengePopup extends App.Views.Shared.Popup
  className: 'challenge_popup'
  render:->
    super()
    @partial @popup, 'games/challenge',
      model: @model
      self:  @options.self
