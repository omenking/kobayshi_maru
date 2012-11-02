class App.Collections.Games extends Backbone.Collection
  model: App.Models.Player
  url:=> '/games'
  self:=>
    _.find @models, (model)=>
      model.get 'self'
  comparator:(model)->
    m = model.get 'self'
    -m

