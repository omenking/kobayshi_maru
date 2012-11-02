class Card
  extend ActiveModel::Naming

  attr_accessor  :id,
                 :kind,
                 :name,
                 :tech,
                 :weapons,
                 :energy,
                 :damage,
                 :shields,
                 :health,
                 :description,
                 :special

  def initialize attrs={}
    attrs.each do |name, value|
      send "#{name}=", value
    end
  end

end
