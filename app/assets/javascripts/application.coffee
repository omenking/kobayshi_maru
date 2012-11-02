#= require lib/jquery
#= require lib/jquery-ui
#= require lib/inflection
#= require lib/underscore
#= require lib/backbone
#= require lib/auth_token_sync.js
#= require lib/init
#= require lib/jenny
#= require lib/milk
#= require lib/backpusher
#= require template

#= require_tree ./models
#= require_tree ./collections
#= require_tree ./routers
#= require_tree ./views
#= require_tree ./helpers


###
Get the current coordinates of the first element in the set of matched
elements, relative to the closest positioned ancestor element that
matches the selector.
@param {Object} selector
###
jQuery.fn.positionAncestor = (selector) ->
  left = 0
  top  = 0
  @each (index, element) ->
    # check if current element has an ancestor matching a selector
    # and that ancestor is positioned
    $ancestor = $(this).closest(selector)
    if $ancestor.length and $ancestor.css("position") isnt "static"
      $child                  = $(this)
      childMarginEdgeLeft     = $child.offset().left    - parseInt($child.css("marginLeft"), 10)
      childMarginEdgeTop      = $child.offset().top     - parseInt($child.css("marginTop"), 10)
      ancestorPaddingEdgeLeft = $ancestor.offset().left + parseInt($ancestor.css("borderLeftWidth"), 10)
      ancestorPaddingEdgeTop  = $ancestor.offset().top  + parseInt($ancestor.css("borderTopWidth"), 10)
      left                    = childMarginEdgeLeft     - ancestorPaddingEdgeLeft
      top                     = childMarginEdgeTop      - ancestorPaddingEdgeTop
      # we have found the ancestor and computed the position stop iterating
      false
  left: left
  top: top






$ ->
  App.discard     = false
  App.discard_ids = []
  App.socket_id = ()=>
    App.pusher.connection.socket_id
  App.pusher = new Pusher '98a2b45cf969ea141c81'
  App.backer = (key,e)=>
    options        = {}
    if e.events
      events = {}
      _.each e.events, (name,ev)->
        events[ev] = e[name]
      options.events = events
    channel = App.pusher.subscribe key
    Backpusher channel, e, options

  App.Helpers.Base.detect_router()
  #game_loop = ()=>
    #url = 'player/messages'
    #$.ajax
      #url      : url,
      #dataType : 'json'
      #context  : this
      #success  : ()->
        #console.log '----'
        #console.log arguments

  #setInterval game_loop, 1000
