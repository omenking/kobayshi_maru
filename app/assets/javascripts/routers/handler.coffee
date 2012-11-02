class App.Routers.Handler extends Backbone.Router
  initialize:->
    @watch()
  watch:->
    console.log 'watch'
