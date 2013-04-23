class Stock < ActiveRecord::Base
  attr_accessible :symbol

  validates :symbol, :uniqueness => true
  has_many :quotes, :dependent => :destroy
  accepts_nested_attributes_for :quotes


  def history_percent
  	win = quotes.where(:history_win => true).size
    predicted_up = quotes.where(:history_prediction => "Up").size
    predicted_down = quotes.where(:history_prediction => "Down").size
    playable_quotes = predicted_up + predicted_down

    self.history_win_percentage = ((win.to_f / playable_quotes)*100).round(2) 
  end

  def recent
    future = quotes.where(:date > Date.today)
  end




  def percent
  	win = quotes.where(:win => true).size
    failed_quotes = quotes.where(:prediction => 'fail').size
  	total = quotes.size - failed_quotes
  	if total > 0
  	  self.win_percentage = ((win.to_f / total)*100).round(2)
  	else
  	 self.win_percentage = 0
  	end
  end

  
end
