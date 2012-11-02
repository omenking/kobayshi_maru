#     Backpusher.js 0.0.2
#     (c) 2011-2012 Pusher.
#     Backpusher may be freely distributed under the MIT license.
#     For all details and documentation:
#     http://github.com/pusher/backpusher

# The top-level namespace. All public Backbone classes and modules will
# be attached to this. Exported for both CommonJS and the browser.
Backpusher = (channel, collection, options) ->
  return new Backpusher(channel, collection, options)  unless this instanceof Backpusher
  
  # Bind for the connection established, so
  # we can setup the socket_id param.
  if channel.pusher.connection
    channel.pusher.connection.bind "connected", ->
      Backbone.pusher_socket_id = channel.pusher.connection.socket_id

  else
    channel.pusher.bind "pusher:connection_established", ->
      Backbone.pusher_socket_id = channel.pusher.socket_id

  
  # Options is currently unused:
  @options = (options or {})
  @channel = channel
  @collection = collection
  if @options.events
    @events = @options.events
  else
    @events = Backpusher.defaultEvents
  @_bindEvents()
  @initialize channel, collection, options

_.extend Backpusher::, Backbone.Events,
  initialize: ->

  _bindEvents: ->
    return  unless @events
    for event of @events
      @channel.bind event, _.bind(@events[event], this)

  _add: (model) ->
    Collection = @collection
    model = new Collection.model(model)
    Collection.add model
    @trigger "remote_create", model
    model

Backpusher.defaultEvents =
  created: (pushed_model) ->
    @_add pushed_model

  updated: (pushed_model) ->
    model = @collection.get(pushed_model)
    if model
      model = model.set(pushed_model)
      @trigger "remote_update", model
      model
    else
      @_add pushed_model

  destroyed: (pushed_model) ->
    model = @collection.get(pushed_model)
    if model
      @collection.remove model
      @trigger "remote_destroy", model
      model


# Add socket ID to every Backbone.sync request
origBackboneSync = Backbone.sync
Backbone.sync = (method, model, options) ->
  options.headers = _.extend(
    "X-Pusher-Socket-ID": Backbone.pusher_socket_id
  , options.headers)
  origBackboneSync method, model, options


# Export:
@Backpusher = Backpusher
