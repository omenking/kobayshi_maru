class App.Views.Games.Show extends Backbone.View
  events:
    'click .discard'         : 'discard'
    'click .discard_confirm' : 'discard_confirm'
    'click .leave'           : 'leave_game'
  initialize:=>
    @model.bind 'change', @render
    @model.bind 'leave' , @leave
    @model.bind 'end'   , @end
    App.game = @model
    App.backer "game_#{@model.id}", @model
  render:=>
    App.discard = false
    App.discard_ids = []
    App.cards ||= @model.get 'cards'

    last_cards = @model.get 'last_cards'
    if last_cards
      _.each last_cards, (card)=>
        attrs = _.find App.cards, (c)=>
          c.id == card.id
        attrs.card_id = card.id
        html  = @template 'cards/card', attrs
        el    = $($('.card')[card.index])
        el.addClass attrs.kind
        el.html html
        el.css 'z-index', 2
        pos_start = el.positionAncestor '.content'
        pos_fin   = $('.discard_pile').positionAncestor '.content'
        top  = pos_fin.top  - pos_start.top
        left = pos_fin.left - pos_start.left
        el.animate {
          top  : top
          left : left },
          complete: =>
            setTimeout @setup, 1000
    else
      @setup()
  setup:=>
    @el_template 'games/show'
    @setup_player 1
    @setup_player 2
    @setup_hand()
  setup_player:(pos)=>
    name    = "player_#{pos}"
    attrs   = @model.get name
    @[name] = new App.Models.Player attrs
    @self   = @[name] if @[name].get 'self'
    @partial ".#{name}_stats", 'games/stats'
      model : @[name],
      pos   : pos
    count =  @[name].get 'shield_strength'
    count = parseInt count
    per   = if count >= 40
      1
    else
      count / 40
    $(".ship_#{pos} .shield").css 'opacity', per
  setup_hand:=>
    if @model.get 'my_turn'
      @cards = @collect 'cards', el: '.cards_wrap'
      @cards.reset @self.hand()
  discard:=>
    e = @$('.discard')
    active = e.hasClass 'active'
    if active
      e.removeClass 'active'
      App.discard = false
    else
      e.addClass 'active'
      App.discard = true
  discard_confirm:=>
    @$('.discard').removeClass         'active'
    @$('.discard_confirm').removeClass 'active'

    _.each App.discard_ids, (pos)=>
      offset = @offset_to_pile pos
      card  = $($('.card')[pos])
      card.css 'z-index', 2
      card.animate offset,
        complete: @discard_cards

  offset_to_pile:(pos)=>
    pos_start = $($('.card')[pos]).positionAncestor '.content'
    pos_fin   = $('.discard_pile').positionAncestor '.content'

    top  = pos_fin.top  - pos_start.top-15
    left = pos_fin.left - pos_start.left
    {top: top, left: left}
  discard_cards:=>
    data = 
      handle : 'discard'
      id     : App.discard_ids
      socket_id: App.socket_id()
    @post '/loop', (data)=>
      App.game.set data
    , data
  leave:(data)=>
    @popup = @partial null, 'games/left_popup', data: data
    @popup.pop()
  end:(data)=>
    @popup = @partial null, 'games/end_popup', data: data
    @popup.pop()
  leave_game:=>
    if confirm 'Are you sure you want to leave the game?'
      window.location.href = '/games/leave'
