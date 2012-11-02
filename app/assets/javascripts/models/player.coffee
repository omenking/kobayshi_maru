class App.Models.Player extends Backbone.Model
  events:
    challenge : 'challenge'
    accept    : 'accept'
  url:=> '/player'
  challenge:(id)=>
    @trigger 'challenge', id
  accept:(id)=>
    @trigger 'accept', id
  hand:->
    ids   = @attributes.hand_ids
    cards = _.filter App.cards, (card)=>
      _.include ids, card.id

    cards = _.map ids, (id)=>
      _.find cards, (card)=>
        card.id is id

    _.map cards, (card,i)=>
      card = _.clone card
      card.card_id = card.id
      card.id      = i
      card         = new App.Models.Card card
      card.player  = @
      card

