class App.Views.Games.Challenge extends Backbone.View
  events:
    'click .button': 'accept'
  initialize:->
    @render()
  render:->
    @el_template 'games/challenge'
  accept:->
    @$('.button').hide()
    id = @model.id
    @post "players/#{id}/accept", (id)=>
      window.location.href = "games/#{id}"
