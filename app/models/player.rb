class Player < ActiveRecord::Base
  #5 - scan
  #7 - bypass shields
  #9 - steal resources, 8 of each, no more than opponent has
  #10 - + 1 commander
  #12 - dampening field - no resources next turn
  #13 - all generate +1 weapons
  #14 - steal a card
  #15 - +1 scientist
  #20 - evade
  #21 - double attack
  #22 - +8 weapons
  #23 - +8 tech
  #24 - +8 energy
  #25 - -8 weapons
  #26 - -8 tech
  #27 - -8 energy
  #28 - all +1 tech tech next turn
  #29 - +1 engineer
  #35 - +1 eng, com, sci
  #40 - al +1 energy
  #42 - drain shields by 3

  SCAN = 5
  BYPASS_SHIELDS = 7
  STEAL = 9
  RECRUIT_COMMANDER = 10
  DAMPENING_FIELD = 12
  ALL_WEAPONS = 13
  SABOTAGE = 14
  RECRUIT_SCIENTIST = 15
  EVADE = 20
  DOUBLE_ATTACK = 21
  MAKE_WEAPONS = 22
  MAKE_TECH = 23
  MAKE_ENERGY = 24
  DESTROY_WEAPONS = 25
  DESTROY_TECH = 26
  DESTROY_ENERGY = 27
  ALL_TECH = 28
  RECRUIT_ENGINEER = 29
  RECRUIT_ALL = 35
  ALL_ENERGY = 40
  REVERSE = 42

  scope :active, -> {
    where('updated_at > ?', DateTime.now - 1.minute) }
  scope :not_active, -> {
    where('updated_at <= ?', DateTime.now - 1.minute) }

  CARDS_PER_HAND = 8
  after_initialize :create_guest_name

  attr_accessible :name

  has_many :messages,
    class_name: 'PlayerMessage'
  belongs_to :game

  def create_guest_name
    self.name ||= "guest#{rand(9999)}"
  end

  def my_turn?
    game.current_player == self
  end

  def opponent
    game.players.reject{|p| p == self}.first
  end

  def discard! socket_id, *args
    last_cards = args.collect do |n|
      card = hand[n]
      remove_card_from_hand! n
      {id:card.id,index:n}
    end
    end_move! socket_id, last_cards
  end

  def damage!(amount)
    puts "Receiving damage #{amount}"
    if is_special?(:evade)
      puts "Evading"
      remove_special :evade
      save
      return
    end

    if shield_strength >= amount
      puts "Dmg absorved by shields"
      decrement! :shield_strength, amount
      amount = 0
    elsif shield_strength > 0
      amount -= shield_strength
      puts "Dmg removed shields"
      decrement! :shield_strength, shield_strength
    end
    return if amount == 0

    puts "Damaging ship"
    if ship_strength > amount
      decrement! :ship_strength, amount
    else
      update_attribute :ship_strength, 0
    end
  end

  def direct_damage!(amount)
    puts "Direct damage #{amount}"
    decrement! :ship_strength, amount
  end

  def increase_shields! amount
    increment! :shield_strength, amount
  end

  def heal! amount
    increment! :ship_strength, amount
  end

  def can_play?(card_index)
    card = hand[card_index]
    card.tech <= tech && card.weapons <= weapons && card.energy <= energy
  end

  def playable
    (0..7).collect do |n|
      if can_play?(n)
        [n, hand[n].description, can_play?(n)]
      else
        [n]
      end
    end
  end

  def recruit! *args
    args.each do |type|
      method = type.to_s.pluralize
      self.send("#{method}=", send(method) + 1)
    end
  end

  def drain! type, amount
    if send(type) >= amount
      decrement! type, amount
      amount
    else
      result = send(type)
      update_attribute type, 0
      result
    end
  end

  def add_special value
    current = special.split(',')
    current << value
    self.special = current.join(',')
  end

  def is_special? value
    self.special.split(',').include?(value.to_s)
  end

  def remove_special value
    current = self.special.split(',')
    current.delete(value.to_s)
    self.special = current.join(',')
  end

  def play! socket_id, card_index
    raise 'Not your turn' unless my_turn?
    raise 'OOB' if card_index > 7
    raise 'You cant play this card' unless can_play?(card_index)

    card = hand[card_index]

    case card.id
    when RECRUIT_COMMANDER
      recruit! :commander
    when RECRUIT_SCIENTIST
      recruit! :scientist
    when RECRUIT_ENGINEER
      recruit! :engineer
    when RECRUIT_ALL
      recruit! :engineer, :scientist, :commander
    when MAKE_WEAPONS
      increment! :weapons, 8
    when MAKE_TECH
      increment! :tech, 8
    when MAKE_ENERGY
      increment! :energy, 8
    when DESTROY_ENERGY
      opponent.drain! :energy, 8
    when DESTROY_TECH
      opponent.drain! :tech, 8
    when DESTROY_WEAPONS
      opponent.drain! :weapons, 8
    when ALL_WEAPONS
      add_special :all_weapons
    when ALL_TECH
      add_special :all_tech
    when ALL_ENERGY
      add_special :all_energy
    when DAMPENING_FIELD
      opponent.add_special :dampening_field
    when SCAN
    when BYPASS_SHIELDS
      opponent.direct_damage! card.damage
    when STEAL
      increment! :tech, opponent.drain!(:tech, 8)
      increment! :weapons, opponent.drain!(:weapons, 8)
      increment! :energy, opponent.drain!(:energy, 8)
    when SABOTAGE
    when DOUBLE_ATTACK
      add_special :double_attack
    when EVADE
      add_special :evade
    when REVERSE
      amount = 5
      if shield_strength >= 3
        amount += 3
        decrement! :shield_strength, 3
      else
        amount += shield_strength
        update_attribute :shield_strength, 0
      end
      increment! :ship_strength, amount
    else
      puts "Card has #{card.damage} damage"
      if card.damage > 0
        damage = card.damage
        if is_special?(:double_attack)
          remove_special :double_attack
          damage *= 2
        end
        puts "Causing #{damage} damage"
        opponent.damage! damage
      end
      increase_shields! card.shields if card.shields > 0
      heal! card.health if card.health > 0
    end

    self.tech -= card.tech
    self.weapons -= card.weapons
    self.energy -= card.energy

    self.save

    remove_card_from_hand! card_index


    last_cards = [ {id:card.id,index:card_index} ]
    end_move! socket_id, last_cards
  end

  def end_move! socket_id, last_cards=[]
    game.update_attribute :last_move_player_id, id

    id    = game.id
    key   = "game_#{id}"

    if game.player_1.ship_strength == 0
      attrs = {
        id: game.player_2.id,
        name: game.player_2.name
      }
      push key, :end, attrs
    elsif game.player_2.ship_strength == 0
      attrs = {
        id: game.player_1.id,
        name: game.player_1.name
      }
      push key, :end, attrs
    elsif game.current_player == game.player_1
      grant_resources!
      opponent.grant_resources!
    end

    game.player_1.reload
    game.player_2.reload
    attrs = Rabl::Renderer.new 'games/loop', game,
                               view_path: 'app/views',
                               format:    'json',
                               locals:    { _player: game.current_player,
                                            last_cards: last_cards }
    attrs = attrs.render
    push key, :turn, attrs, socket_id
    game
  end

  def grant_resources!
    puts "Grant resources to #{self}"
    if is_special?(:dampening_field)
      remove_special :dampening_field
      save
      return
    end

    if is_special?(:all_weapons)
      remove_special :all_weapons
      self.weapons += scientists + commanders + engineers
      puts "Giving all weapons"
    elsif is_special?(:all_tech)
      remove_special :all_tech
      self.tech += scientists + commanders + engineers
      puts "Giving all tech"
    elsif is_special?(:all_energy)
      remove_special :all_energy
      self.energy += scientists + commanders + engineers
      puts "Giving all energy"
    else
      puts "Giving normally"
      self.tech += scientists
      self.weapons += commanders
      self.energy += engineers
    end
    self.save
  end

  def remove_card_from_hand! card_index
    new_hand = hand
    next_card = deck.cards.shift
    self.deck = deck
    if deck.cards.none?
      self.deck = Deck.new
    end
    new_hand[card_index] = next_card
    self.hand = new_hand
    save
  end

  def reset!
    self.shield_strength = 10
    self.ship_strength = 24
    self.commanders = 2
    self.weapons = 5
    self.scientists = 2
    self.tech = 5
    self.engineers = 2
    self.energy = 5
    self.deck = Deck.new
    self.deal_hand
    self.save
  end

  def deal_hand
    self.hand = @deck.cards.shift(CARDS_PER_HAND)
    self.deck = @deck
  end

  def hand=(cards)
    self.hand_card_ids = cards.collect{|c| c.id}.join(',')
  end

  def hand
    hand = []
    hand_card_ids.split(',').each do |card_id|
      card = DECK.select{|c| c.id == card_id.to_i}.first
      hand << card
    end
    hand
  end

  def send_message!(message)
    self.messages.create message: message
  end

  def challenge! player
    key = "player_#{player.id}"
    push key, :challenge, self.id
  end

  def accept! player
    key  = "player_#{player.id}"
    game = Game.create player_1: player,
                       player_2: self
    game.start!
    push key, :accept, game.id
    game
  end

  def deck=(value)
    @deck = value
    self.deck_card_ids = @deck.cards.collect(&:id).join(',')
  end

  def deck
    return nil unless deck_card_ids
    unless @deck
      deck = []
      deck_card_ids.split(',').each do |card_id|
        card = DECK.select{|c| c.id == card_id.to_i}.first
        deck << card
      end
      @deck = Deck.new(deck)
    end
    @deck
  end

  def attrs 
    {
      id: id,
      name: name
    }
  end

  def push key, action, attrs, socket_id=nil
    Pusher[key.to_s].trigger action.to_s, attrs, socket_id
  end

  def hand_ids
    if hand_card_ids
      ids = hand_card_ids.split ',' 
      ids.map! &:to_i
    end
    ids || []
  end
end
