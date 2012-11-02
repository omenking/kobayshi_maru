class App.Models.Game extends Backbone.Model
  events:
    'turn'  : 'turn'
    'end'   : 'end'
    'leave' : 'leave'
  url:=>
    if @isNew()
      '/games'
    else
      "/games/#{@id}"
  turn:(data)=>
    @set data
  end:(data)=>   @trigger 'end', data
  leave:(data)=> @trigger 'leave', data
