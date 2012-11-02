class PlayersController < ApplicationController
  def show
  end

  def update
    _player.update_attributes params[:player]
    push :players, :updated, _player.attrs
    render nothing: true
  end

  def challenge
    id = params[:id]
    @player = Player.find id
    _player.challenge! @player
    render nothing: true
  end

  def touch
    _player.touch

    @remove_players = Player.not_active.where('updated_at > ?',DateTime.now - 75.seconds).order('updated_at DESC')
    @remove_players.each do |player|
      Rails.logger.info "Destroy #{player.inspect}"
      push "players", :destroyed, player.attrs
    end

    render nothing: true
  end

  def accept
    id      = params[:id]
    @player = Player.find id
    @game    = _player.accept! @player
    render json: @game.id
  end

  def push key, action, attrs
    Pusher[key.to_s].trigger action.to_s, attrs
  end
end
