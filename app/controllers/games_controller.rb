class GamesController < ApplicationController
  def index
    if game = Game.with_player(_player).first
      redirect_to game_path(game)
      return
    end
    respond_to do |f|
      f.html
      f.json do
        @games = Player.active.all
      end
    end
  end

  def leave
    current_player = _player
    game = _player.game
    key = "game_#{game.id}"
    attrs = { id: _player.id, name: _player.name }

    game = _player.game
    game.player_1.update_attribute :game_id, nil
    game.player_2.update_attribute :game_id, nil
    game.update_attribute :player_1, nil
    game.update_attribute :player_2, nil

    redirect_to '/'

    push key, :leave, attrs
  end

  def show
    @game = Game.find params[:id]
  end

  def loop
    if _player.my_turn?
      handle    = params[:handle]
      id        = params[:id]
      socket_id = params[:socket_id]
      @game = case handle
        when 'play'
          _player.play! socket_id, id.to_i
        when 'discard'
          _player.discard! socket_id, *id.map(&:to_i)
      end
      @game.player_1.reload
      @game.player_2.reload
    end
  end

  def push key, action, attrs, socket_id=nil
    Pusher[key.to_s].trigger action.to_s, attrs, socket_id
  end
end
