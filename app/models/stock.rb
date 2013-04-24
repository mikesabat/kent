class Stock < ActiveRecord::Base
  attr_accessible :symbol, :history_win_percentage

  validates :symbol, :uniqueness => true
  has_many :quotes, :dependent => :destroy
  accepts_nested_attributes_for :quotes
  scope :winning, where('history_win_percentage > 60') 
  scope :losing, where('history_win_percentage < 40') 


  def history_percent
  	win = quotes.where(:history_win => true).size
    predicted_up = quotes.where(:history_prediction => "Up").size
    predicted_down = quotes.where(:history_prediction => "Down").size
    playable_quotes = predicted_up + predicted_down

    self.history_win_percentage = ((win.to_f / playable_quotes)*100).round(2) 
    self.save
  end

  
end
