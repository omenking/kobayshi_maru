$.ajaxSetup
  beforeSend:(xhr)->
    xhr.setRequestHeader 'Accept', 'application/json'
  cache: false

ViewHelpers=
  el_template:(path,attrs=null)->
    unless attrs
      attrs = {}
      attrs = @model.attrs() if @model
    html  = @template path, attrs
    $(@el).html html
  fire:(event)->
    $(@el).trigger event
  bind_render:->
    _.bindAll        @       , 'render'
    @collection.bind 'add'   , @render
    @collection.bind 'remove', @render
    @collection.bind 'reset' , @render

ModelHelpers=
  get:(attr)->
    old_attr    = @attributes[attr]
    is_function = typeof @[attr] is 'function'
    return @[attr](old_attr) if is_function
    old_attr
  attrs:->
    attrs       = {}
    self        = @
    attrs       = @toJSON()
    attrs['id'] = @id if @id
    if @include_attrs
      _.each @include_attrs, (attr)=>
        attrs[attr] = @[attr]()
    _.each attrs, (value,attr)=>
      attrs[attr] = @get attr
    attrs
CollectionHelpers =
  # @collection.collect
  # ---------------
  #
  # This method is best used with the BackboneHelpers.collect
  # In your view that has a collection you can call collect on
  # the collection and it will render the the individual models
  # if you used BackboneHelpers.collect to render the current
  # view all you have to do now is:
  #
  #    (assuming @collect 'projects' was called)
  #    @collection.collect
  #
  #  This would render the template 'projects/index' and attach
  #  it the '.projects'
  #
  #  if you don't want to render a template because it already exists
  #  you can just set template_index to false
  collect:->
    e         = $ @context.el
    find      = arguments[0]
    has_find  = find isnt undefined && find isnt null
    options   = arguments[1] || {}

    template_index     = options.template_index
    primer             = options.primer
    template_index     = template_index   || "#{@name}/index"           unless template_index is false
    primer             = primer           || "#{template_index}_primer" unless primer         is false
    template           = options.template || "#{@name}/#{@name.singularize()}"

    #ensure not passed to partial
    delete options.template_index
    delete options.template
    delete options.primer

    if template_index
      attrs = {}
      attrs = options.model.attrs() if options.model
      html  = @context.template template_index, attrs
      e.html html
    selector = e

    if @length isnt 0
      selector = e.find find if has_find
      selector.empty()       if selector
      models = @context.collection.models
      _.each models, (model)=>
        options.model = model
        e = @context.partial null, template, options
        selector.append e.el
    else if primer
      html = @context.template primer, {}
      e.addClass 'primer'
      e.html html
BackboneHelpers =
  redirect_on_browse:->
    if @browsing()
      return window.location.pathname = '/signup'
    else
      false
  browsing:->
    $('body').hasClass('logged_out')
  hash:(i=null)->
    e = window.location.hash.replace /#/, ''
    e = e.replace /\?.+$/, ''
    e = e.split '/'
    if i then e[i] else e
  template: (path,data)->
    template = null
    eval "template = Template.#{path.replace(/\//g,'.')}"
    new throw "template is undefined: Template.#{path.replace(/\//g,'.')}" if template is undefined
    Milk.render template, data

  # collect
  # ---------------
  # This method makes it easy to quickly render a collection.
  # all you need to do is pass in the name of the collection you
  # want to be rendered eg.
  #
  #    collect 'projects'
  #
  # el:       override selector             default: .plural_name
  # url:      override url for collection   default: /pluaral_name
  # template: override template for index   default: pluaral_name/index
  # id:       when dealing with assocations eg. collect 'projects/tasks', id: 5
  # model:    override model name           default: Appl.Model.singular_name
  # options:  will pass through options to partial index
  #
  # If your dealing with an association:
  #
  #   collect 'projects/tasks', id: 5
  #
  # It will create a collection in this case App.Collections.Projects
  # with the model being App.Models.Project and an url with '/projects'.
  # The collection will be assigned to the @collection instance variable
  # so you can reference it in your view. It will not invoke fetch().
  #
  # It will also called @partial '.projects', 'projects/index' and
  # attach the collection and whatever options you pass to to the
  # collect method.
  #
  # If you want to override the el of the partial you just need to specify
  # the el the option. eg.
  #
  #    @collect 'users', el: '.people'
  #
  # If you want to override the partial path thats being used in the partial you just
  # need to specify the template option (probably should not be called template since
  # that might confuse people with the actual template being render) eg.
  #
  #    #collect 'users', template: 'awesome_people/index'
  #
  # If you want to override the model being use you need to pass just the
  # model name to the model option eg.
  #
  #    @collect 'groups', model: 'community'
  #
  collect:->
    name         = arguments[0]
    options      = arguments[1]
    options    ||= {}
    partial_opts = options.options

    id         = options.id
    url        = options.url || @_build_context_url(name,id) || "/#{name}"

    model_name = options.model || @model_name || name.singularize()
    model_name = model_name.camelize()
    #Setup Collection -------------------------------
    collection_name   = options.collection || name
    collection_name   = collection_name.camelize()

    if App.Collections[collection_name] is undefined
      console.log "Error in: @collection.collect"
      console.log "> App.Collections.#{collection_name} isn't defined"
      console.log '> arguments being passed:'
      console.log arguments

    if App.Models[model_name] is undefined
      console.log "Error in: @collection.collect"
      console.log "> App.Models.#{model_name} isn't defined"
      console.log '> arguments being passed:'
      console.log arguments

    @collection       = new App.Collections[collection_name]
    @collection.model = App.Models[model_name]
    @collection.url   = url
    @collection.name  = name

    # ResultsModel ----------------------------------
    result_model = @result_model || "#{model_name}Result"
    if App.Models[result_model]
      @collection.results_model = new App.Models[result_model]()
      @collection.results_model.collection = @collection

    selector = options.el       || ".#{name}"
    template = options.template || "#{name}/index"

    delete options.id
    delete options.url
    delete options.template
    delete options.el
    delete options.collection
    delete options.model
    delete options.options

    options = _.extend options, partial_opts if partial_opts

    options.collection = @collection

    e = @partial selector, template, options
    @collection.context = e

    @collection
  _build_context_url:(name,id)->
    return unless name.match(/\//)
    e       = name.split '/'
    context = e[0]
    name    = e[1]
    reg     = new RegExp "#{context}\\/(\\d+)"
    "/api/#{context}/#{id}/#{name}"
  partial:->
    el      = arguments[0]
    name    = arguments[1]
    options = arguments[2]
    scope = 'App'
    e = name.split '/'
    options      ||= {}

    if el != null
      el = if typeof(el) is 'string' && el.match /@/
        el = el.replace /@/, ''
        $(@el).find el
      else
        el
      options['el'] = el
    p = (item.camelize() for item in e)
    eval "var p = new #{scope}.Views.#{p.join('.')}(options)"
    instance_var = e.join('_')
    @[instance_var] = p
  post:(url,success,data={})->
    token = $("meta[name='csrf-token']").attr('content')
    data['authenticity_token'] = token
    $.ajax
      type     : 'post'
      url      : url,
      data     : data
      dataType : 'json'
      context  : this
      success  : success
  get:(url,success,data)->
    $.ajax
      url      : url,
      data     : data
      dataType : 'json'
      context  : this
      success  : success
  resize:->
    App.Helpers.Base.resize_panels()
_.extend Backbone.Router.prototype    , BackboneHelpers
_.extend Backbone.View.prototype      , BackboneHelpers
_.extend Backbone.View.prototype      , ViewHelpers
_.extend Backbone.Model.prototype     , ModelHelpers
_.extend Backbone.Collection.prototype, CollectionHelpers

cx_backbone_common =
  sync: (method, model, options) ->
    # Changed attributes will be available here if model.saveChanges was called instead of model.save
    if method == 'update' && model.changedAttributes()
      options.data = JSON.stringify(model.changedAttributes())
      options.contentType = 'application/json';
    Backbone.sync.call(this, method, model, options)

cx_backbone_model =
  # Calling this method instead of set will force sync to only send changed attributes
  # Changed event will not be triggered until after the model is synced
  saveChanges: (attrs) ->
    @save(attrs, {wait: true})

_.extend(Backbone.Model.prototype, cx_backbone_common, cx_backbone_model)
_.extend(Backbone.Collection.prototype, cx_backbone_common)
