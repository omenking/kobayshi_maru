class Hand
  attr_reader :cards
  CARDS_PER_HAND = 8
  def initialize(*args)
    options = args.extract_options!
    @deck = options[:deck]
    @cards = []
    CARDS_PER_HAND.times { @cards << @deck.next_card }
  end
end
