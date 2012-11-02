class MessagesController < ApplicationController
  def index
    @messages = _player.messages.to_a
    _player.messages.destroy_all
    respond_to do |f|
      f.json
    end
  end
end
