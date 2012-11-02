class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :_player
  before_filter :_player



  private
  def _player
    id = session[:player_id]
    if id
      @_player = Player.where(id:id).first || Player.create
      session[:player_id] = @_player.id
      @_player.touch
    else
      @_player = Player.create
      push :players, :created, @_player.attrs
      session[:player_id] = @_player.id
      @_player.touch
    end
    @_player
  end

  def push key, action, attrs
    Pusher[key.to_s].trigger action.to_s, attrs
  end
end
