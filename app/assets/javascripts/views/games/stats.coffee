class App.Views.Games.Stats extends Backbone.View
  initialize:->
    @render()
  render:=>
    pos  = @options.pos
    side = switch pos
      when 1 then 'left'
      when 2 then 'right'
    @el_template "games/stats_#{side}"
    if @model.get 'self'
      $(@el).addClass 'active'
