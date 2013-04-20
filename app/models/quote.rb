require 'nokogiri'
require 'open-uri'
require 'YahooFinance'

class Quote < ActiveRecord::Base
  attr_accessible :date, :eps_actual, :eps_estimate, :neg1_close, :neg1_open, :stock_id, :time, :zero_close, :zero_open, :date_text, :period, :history_prediction, :history_win
  belongs_to :stock
  validates :period, :uniqueness => {:scope => :stock_id,
    :message => "One Quote Per Quarter" }

  after_create :lookup, :price
  



  def lookup
    unless date == nil      
      #puts "77777777#{stock.symbol}*******#{date}***********" #why is the date, 'true'??
        YahooFinance::get_historical_quotes( stock.symbol,
                                        date,
                                        date ) do |row|
                
          self.zero_open = row[1]
          self.zero_close = row[4]
          ddd = row[4]
          #puts "----------------------#{ddd}"  
          self.save 
        end
    

      d = date - 1.day
      if d.wday.between?(1, 4)
         YahooFinance::get_historical_quotes( stock.symbol,
                                          d,
                                          d ) do |row|
                  
            self.neg1_open = row[1]
            self.neg1_close = row[4]
            ddd = row[4]
            #puts "----------------------#{ddd}"  
            self.save 
          end
      end
    end
  end



  def self.grab_data(symbol)
    website = symbol
    doc = Nokogiri::HTML(open("http://www.earnings.com/company.asp?client=cb&ticker=#{website}")){|c|c.options = Nokogiri::XML::ParseOptions::NOBLANKS}
    element = doc.search('//b[text()="Earnings Releases"]').first
    table = element.parent.parent.parent.next#.next >>take out this next because we are skipping blanks which is the {code} following our 'doc' assignment.
    rows = table.search("tr")

    rows.each do |row|
        release = row.search("td").map do |td|
            td.text
        end
        unless release[0] == "SYMBOL" or release[4] == nil

          quote = Quote.new
          @stock = Stock.last #this needs to change or else it will mess something up.
          #puts "*************#{@stock.symbol}*****#{@stock.id}*******************"
          quote.period = release[1]          
          quote.eps_estimate = release[3].delete!("$").to_f
          quote.eps_actual = release[4].delete!("$").to_f
          quote.date_text = release[6]
          quote.stock_id = "#{@stock.id}".to_i #really? How can this be this fucking complicated
          if release[6].include? 'BMO' or release[6].include? '8:00 AM'
            quote.date = Date.parse(release[6])
          elsif release[6].include? 'AMC' or release[6].include? '4:00 PM'
            quote.date = Date.parse(release[6]).next_day(1)
          end  
          quote.save
        end
    end
    
  end
  

  def price  
    

      unless neg1_open == nil or neg1_close == nil
        change = neg1_close - neg1_open
        percent_change = ((change / neg1_open) * 100).round(2).abs
        puts "Price method---Day -1 Open #{neg1_open}---Day -1 Close #{neg1_close}--Change #{change}-percent: #{percent_change}---"
        
        if percent_change > 1
          
          def predict 
            
              if neg1_close > neg1_open
                  self.history_prediction = "Up"
              elsif neg1_open > neg1_close
                  self.history_prediction = "Down"
              else
                  self.history_prediction = "impossible"
              end
          end   

          def track
            if history_prediction == "Up" and zero_open > neg1_close
              self.history_win = true            
            elsif history_prediction == "Down" and zero_open < neg1_close
              self.history_win = true
            else
              
            end
              # elsif prediction == "up" and day_zero_close < day_neg1_close
              #     self.win = false
              # elsif prediction == "down" and day_zero_close > day_neg1_close
              #     self.win = false
              # else
              #     #puts "-----*****-------"
                 #self.win = true          
          end

          self.predict
          track
        
          
        else
          self.history_prediction = "FAIL" 
          self.history_win = nil
        end

      end
    self.save
  end 

end
