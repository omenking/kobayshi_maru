class Deck
  attr_reader :cards

  def initialize(cards=nil)
    @cards = cards || DECK.clone
    shuffle!
    @cursor = 0
  end

  def next_card
    if @cursor + 1 == @cards.length
      shuffle!
      @cursor = 0
    else
      @cursor += 1
    end
    @cards[@cursor]
  end

  def shuffle!
    @cards.shuffle!
  end

  def new_hand
    Hand.new deck: self
  end
end
