class App.Models.Card extends Backbone.Model
  url: ''
  playable:=>
    kind = @get 'kind'
    res = switch kind
      when 'command'  then 'weapons'
      when 'science'  then 'tech'
      when 'engineer' then 'energy'
    cost = @get res
    res  = @player.get res
    cost <= res
