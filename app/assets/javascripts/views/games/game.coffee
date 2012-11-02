class App.Views.Games.Game extends Backbone.View
  className: 'game'
  events:
    'click .button': 'show'
  initialize:->
    @model.bind 'change', @render
    @render()
  render:=>
    @el_template 'games/game'
    self = @model.get 'self'
    $(@el).addClass 'self' if self
  show:=>
    id = @model.id
    @post "players/#{id}/challenge"
