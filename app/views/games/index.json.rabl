collection @games
attributes :id, :name

node :self do |player|
 player.id == _player.id
end
