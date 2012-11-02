class App.Views.Games.Index extends Backbone.View
  initialize:->
    @bind_render()
  render:=>
    @collection.collect '.games'
      primer: false
    @model  = @collection.self()
    id      = @model.id
    name    = @model.get 'name'

    App.backer "player_#{id}", @model
    @model.bind 'challenge', @challenge
    @model.bind 'accept'   , @accept

    @$('#name').val name
    @$('#name').keyup _.debounce @query, 600
    setInterval @touch, 5000
  touch:=>
    $.get '/player/touch'
  query:(e)=>
    name = $(e.currentTarget).val()
    @model.save name: name
  challenge:(id)=>
    model = @collection.get id
    @popup = @partial null, 'games/challenge_popup',
      model: model
      self : @model
    @popup.pop()
  accept:(id)=>
    window.location.href = "games/#{id}"
