class App.Routers.Games.Index extends Backbone.Router
  routes:
    '': 'index'
  index:->
    @collect 'games',
      el   : '.content'
      model: 'player'
    @collection.fetch()
    App.backer 'players', @collection
