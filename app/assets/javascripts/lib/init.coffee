list = '''
Games
Cards
Shared
'''

list = list.split "\n"

window.App =
  Collections : {}
  Models      : {}
  Routers     : {}
  Views       : {}
  Helpers     : {}

_.each list, (i)=>
  App.Routers[i]   = {}
  App.Views[i]     = {}
