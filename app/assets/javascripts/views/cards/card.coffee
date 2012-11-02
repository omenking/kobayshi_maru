class App.Views.Cards.Card extends Backbone.View
  events:
    'click': 'play'
  className: 'card'
  initialize:->
    @render()
  render:->
    @el_template 'cards/card'
    @apply_attrs()
  apply_attrs:=>
    unless @model.playable()
      $(@el).addClass 'disable'
    kind = @model.get 'kind'
    $(@el).addClass kind
  play:=>
    if App.discard
      active = $(@el).hasClass 'active'
      if active
        $(@el).removeClass 'active'
        App.discard_ids = _.without App.discard_ids, @model.id
      else
        $(@el).addClass 'active'
        App.discard_ids.push @model.id
      if App.discard_ids.length isnt 0
        $('.discard_confirm').addClass 'active'
    else
      if @model.playable()
        offset = @offset_to_pile()
        $(@el).css 'z-index', 2
        $(@el).animate offset,
          complete: @play_card
  offset_to_pile:=>
    pos_start = $(@el).positionAncestor '.content'
    pos_fin   = $('.discard_pile').positionAncestor '.content'

    top  = pos_fin.top  - pos_start.top
    left = pos_fin.left - pos_start.left
    {top: top, left: left}
  play_card:=>
    data = 
      handle : 'play'
      id     : @model.id
      socket_id: App.socket_id()
    @post '/loop', (data)=>
      App.game.set data
    , data
