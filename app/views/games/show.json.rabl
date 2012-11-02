object @game
attributes :id

game = @game
_player = @_player
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

child CARDS => :cards do
  attributes :id,
             :kind,
             :name,
             :tech,
             :weapons,
             :energy,
             :damage,
             :shields,
             :health,
             :description,
             :special
end

