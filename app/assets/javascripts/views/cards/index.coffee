class App.Views.Cards.Index extends Backbone.View
  initialize:->
    @bind_render()
  render:=>
    @collection.collect '.cards'
      template_index: false
      primer: false
