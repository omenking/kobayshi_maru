Template = {"games":{"index":"<div class='profile'>\n  <div class='text_field'>\n    <label for=\"name\">Player name</label>\n    <input id=\"name\" name=\"name\" type=\"text\" />\n  </div>\n</div>\n<div class='games_wrap'>\n  <div class='games'></div>\n  <div class='clear'></div>\n</div>\n","show":"<div class='discard_pile'></div>\n<div class='stats_wrap'>\n  <div class='player_1_stats stats'></div>\n  <div class='player_2_stats stats'></div>\n  <div class='clear'></div>\n</div>\n<div class='viewer'>\n  <div class='ship_1 ship'>\n    <div class='shield'></div>\n  </div>\n  <div class='ship_2 ship'>\n    <div class='shield'></div>\n  </div>\n  <div class='clear'></div>\n</div>\n<div class='table'>\n  <div class='cards_wrap'>\n    <div class='cards'>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='card'></div>\n      <div class='clear'></div>\n    </div>\n  </div>\n  <div class='actions'>\n    <div class='leave'>\n      Surrender\n    </div>\n    {{#my_turn}}\n    <div class='discard'>\n      Jettison cards\n    </div>\n    <div class='discard_confirm'>\n      Confirm\n    </div>\n    {{/my_turn}}\n  </div>\n  <div class='clear'></div>\n</div>\n","game":"<div class='name'>{{name}}</div>\n{{^self}}\n<div class='button'>Play</div>\n{{/self}}\n<div class='clear'></div>\n","challenge":"<div class='message'>\n  <span class='name'>{{name}}</span>\n  is CHALLENGING you for space simulated battle!\n</div>\n<div class='button'>\n  Accept Challenge?\n</div>\n","stats_left":"<div class='stat_group science'>\n  <div class='stat scientist'>{{scientists}}</div>\n  <div class='stat tech'>{{tech}}</div>\n  <div class='clear'></div>\n</div>\n<div class='stat_group engineer'>\n  <div class='stat engineers'>{{engineers}}</div>\n  <div class='stat energy'>{{energy}}</div>\n  <div class='clear'></div>\n</div>\n<div class='stat_group command'>\n  <div class='stat commanders'>{{commanders}}</div>\n  <div class='stat weapons'>{{weapons}}</div>\n  <div class='clear'></div>\n</div>\n<div class='stat_group'>\n  <div class='stat ship'>{{ship_strength}}</div>\n  <div class='stat shields'>{{shield_strength}}</div>\n  <div class='clear'></div>\n</div>\n<div class='clear'></div>\n","stats_right":"<div class='stat_group'>\n  <div class='stat shields'>{{shield_strength}}</div>\n  <div class='stat ship'>{{ship_strength}}</div>\n  <div class='clear'></div>\n</div>\n<div class='stat_group command'>\n  <div class='stat weapons'>{{weapons}}</div>\n  <div class='stat commanders'>{{commanders}}</div>\n  <div class='clear'></div>\n</div>\n<div class='stat_group engineer'>\n  <div class='stat energy'>{{energy}}</div>\n  <div class='stat engineers'>{{engineers}}</div>\n  <div class='clear'></div>\n</div>\n<div class='stat_group science'>\n  <div class='stat tech'>{{tech}}</div>\n  <div class='stat scientist'>{{scientists}}</div>\n  <div class='clear'></div>\n</div>\n<div class='clear'></div>\n","left":"<div class='message'>\n  <span class='name'>\n    {{name}}\n  </span>\n  left the game.\n</div>\n","end_message":"<div class='message'>\n  <span class='name'>\n    {{name}}\n  </span>\n  destroyed your simumlated battle ship!\n</div>\n"},"shared":{"popup":"<div class='pop popup_wrap {{klass}}'>\n  <div class='popup'>\n    <div class='actions'>\n      <a href=\"#\" class=\"close\">Close</a>\n      <div class='clear'></div>\n    </div>\n    <div class='popup_content'></div>\n  </div>\n</div>\n"},"cards":{"card":"<div class='cover'></div>\n<div class='icon'></div>\n<div class='cost'>\n  {{#tech}}\n  <div class='tech'>\n    {{tech}}\n  </div>\n  {{/tech}}\n  {{#weapons}}\n  <div class='weapons'>\n    {{weapons}}\n  </div>\n  {{/weapons}}\n  {{#energy}}\n  <div class='energy'>\n    {{energy}}\n  </div>\n  {{/energy}}\n</div>\n<div class='name'>{{name}}</div>\n<div class='graphic' style='background: url(/assets/cards/{{card_id}}.png) no-repeat'></div>\n<div class='affect'>\n  {{#damage}}\n  <div class='damage'>\n    Attack {{damage}}\n  </div>\n  {{/damage}}\n  {{#shields}}\n  <div class='sheilds'>\n    Shields {{shields}}\n  </div>\n  {{/shields}}\n  {{#health}}\n  <div class='health'>\n    Repairs {{health}}\n  </div>\n  {{/health}}\n  {{#special}}\n  <div class='special'>\n    {{special}}\n  </div>\n  {{/special}}\n</div>\n"}}