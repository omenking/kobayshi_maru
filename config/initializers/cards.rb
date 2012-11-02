require 'csv'

deck      = []
cards     = []
first_row = true
path      = Rails.root.join 'config', 'cards.csv'

CSV.foreach path do |row|
  if first_row
    first_row = false
    next
  end

  quantity = row[1].to_i
  attrs    = {
    id:          row[0].to_i,
    kind:        row[2],
    name:        row[3],
    tech:        row[4].to_i,
    weapons:     row[5].to_i,
    energy:      row[6].to_i,
    damage:      row[7].to_i,
    shields:     row[8].to_i,
    health:      row[9].to_i,
    special:     row[11],
    description: row[10] }
  quantity.times do
    deck.push Card.new attrs
  end
  cards.push Card.new attrs
end

CARDS = cards
DECK  = deck
