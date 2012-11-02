class PlayerMessage < ActiveRecord::Base
  serialize :message
  belongs_to :player

  default_scope order: 'id DESC'

  attr_accessible :message
end
