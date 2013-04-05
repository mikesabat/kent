class Stock < ActiveRecord::Base
  attr_accessible :symbol

  validates :symbol, :uniqueness => true
  has_many :quotes
  accepts_nested_attributes_for :quotes

	  

  #after_save :Quote.grab_data(:symbol)
end
