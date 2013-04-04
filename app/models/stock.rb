class Stock < ActiveRecord::Base
  attr_accessible :symbol

  has_many :quotes
end
