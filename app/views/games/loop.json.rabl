object @game
attributes :id

game = @game
_player = @_player.reload
code :my_turn do
  game.current_player == _player
end

child :player_1 => :player_1 do
  attributes :id,
             :name,
             :shield_strength,
             :ship_strength,
             :commanders,
             :weapons,
             :engineers,
             :energy,
             :scientists,
             :tech
  node :self do |player|
   player.id == _player.id
  end
  node :hand_ids do |player|
    player.hand_ids if player.id == _player.id
  end
end

child :player_2 => :player_2 do
  attributes :id,
             :name,
             :shield_strength,
             :ship_strength,
             :commanders,
             :weapons,
             :engineers,
             :energy,
             :scientists,
             :tech
  node :self do |player|
   player.id == _player.id
  end
  node :hand_ids do |player|
    player.hand_ids if player.id == _player.id
  end
end

last_cards = @last_cards
code :last_cards do
  last_cards
end
