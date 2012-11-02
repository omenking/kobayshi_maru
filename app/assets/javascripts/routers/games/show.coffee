class App.Routers.Games.Show extends Backbone.Router
  routes:
    '': 'show'
  show:=>
    path  = window.location.pathname
    id    = path.match /\d+/
    model = new App.Models.Game(id:id)
    @partial '.content', 'games/show', model: model
    model.fetch()
