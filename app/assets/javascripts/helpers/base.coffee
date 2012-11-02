App.Helpers.Base =
  detect_router:(overrides={})->
    action     = $('body').attr 'action'
    controller = $('body').attr 'controller'
    action     = 'new'  if action is 'create'
    action     = 'edit' if action is 'update'
    controller = controller.camelize()
    action     = action.camelize()

    _.each overrides, (router,selector)->
      if $(selector).length isnt 0
        e          = router.split '/'
        controller = e[0].camelize()
        action     = e[1].camelize()

    new App.Routers[controller][action]()
    Backbone.history.start()
