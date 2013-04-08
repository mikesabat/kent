require 'nokogiri'
require 'open-uri'
require 'YahooFinance'

class Quote < ActiveRecord::Base
  attr_accessible :date, :eps_actual, :eps_estimate, :neg1_close, :neg1_open, :stock_id, :time, :zero_close, :zero_open, :date_text, :period
  belongs_to :stock
  validates :period, :uniqueness => {:scope => :stock_id,
    :message => "One Quote Per Quarter" }

  #after_create :lookup



  def lookup #(symbol, date)
      YahooFinance::get_historical_quotes( stock.symbol,
                                      date,
                                      date ) do |row|
              
              self.zero_open = row[1]
              self.zero_close = row[4]        
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
  


end
