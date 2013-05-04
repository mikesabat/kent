class Stock < ActiveRecord::Base
  attr_accessible :symbol, :history_win_percentage

  validates :symbol, :uniqueness => true
  has_many :quotes, :dependent => :destroy
  accepts_nested_attributes_for :quotes
  scope :winning, where('history_win_percentage > 60') 
  scope :losing, where('history_win_percentage < 40') 



  def history_percent
    #s.quotes.dated.map(&:date)
    #qd_size = quotes.dated.size
    qd = quotes.dated
    #puts "++++++++++qd size#{qd_size}+++++++++++++++"
  	win = qd.select { |x| x.history_win == true }.size
    #puts "+++++++++Wins = +#{win}+++++++++++++++"
    predicted_up = qd.select { |x| x.history_prediction == 'Up' }.size
    #puts "++++++++++Predicted Up#{predicted_up}+++++++++++++++"
    predicted_down = qd.select { |x| x.history_prediction == 'Down' }.size
    #puts "++++++++++Predicted Down#{predicted_down}+++++++++++++++"
    playable_quotes = predicted_up + predicted_down

    self.history_win_percentage = ((win.to_f / playable_quotes)*100).round(2) 
    self.save
  end

  def future_quote_date
    quote_with_date = quotes.where(['date is not null'])
    future_quote_with_date = quote_with_date.where('date > ?', Date.today)
    return future_quote_with_date.date

  end

  def self.order_by_quote_date
   includes(:quotes).order('quotes.date DESC')
  end

  
end
