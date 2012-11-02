class Game < ActiveRecord::Base
  attr_accessible :player_1, :player_2

  belongs_to :player_1,
    class_name: 'Player'
  belongs_to :player_2,
    class_name: 'Player'
  belongs_to :last_move_player,
    class_name: 'Player'

  scope :with_player, ->(player) {
    where('player_1_id = ? OR player_2_id = ?',
          player.id,
          player.id)
  }

  def start!
    players.each do |player|
      push "players", :destroyed, player.attrs
      player.game = self
      player.reset!
    end
  end

  def players
    [player_1, player_2]
  end

  def current_player
    if !last_move_player
      players.first
    else
      players.reject{|c| c == last_move_player}.first
    end
  end

  def state
    puts "#{current_player == player_1 ? '*' : ' '} Player 1 Shl:#{player_1.shield_strength} Shp:#{player_1.ship_strength} Com:#{player_1.commanders}(#{player_1.weapons}) Sci:#{player_1.scientists}(#{player_1.tech}) Enr:#{player_1.engineers}(#{player_1.energy}) #{player_1.special}"
    puts "#{current_player == player_2 ? '*' : ' '} Player 1 Shl:#{player_2.shield_strength} Shp:#{player_2.ship_strength} Com:#{player_2.commanders}(#{player_2.weapons}) Sci:#{player_2.scientists}(#{player_2.tech}) Enr:#{player_2.engineers}(#{player_2.energy}) #{player_2.special}"
  end

  def push key, action, attrs
    Pusher[key.to_s].trigger action.to_s, attrs
  end
end
