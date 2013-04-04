require 'nokogiri'
require 'open-uri'

class Quote < ActiveRecord::Base
  attr_accessible :date, :eps_actual, :eps_estimate, :neg1_close, :neg1_open, :stock_id, :time, :zero_close, :zero_open, :date_text, :period
  belongs_to :stock



  # def lookup(symbol, date)
  #     YahooFinance::get_historical_quotes( symbol,
  #                                     date,
  #                                     date ) do |row|
              
  #             self.zero_open = row[1]
  #             self.zero_close = row[4]        
  #       end
  # end
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
          quote.period = release[1]          
          quote.eps_estimate = release[3].delete!("$").to_f
          quote.eps_actual = release[4].delete!("$").to_f
          quote.date_text = release[6]
          if release[6].include? 'BMO'
            quote.date = Date.parse(release[6])
          elsif release[6].include? 'AMC'
            quote.date = Date.parse(release[6]).next_day(1)
          end          
          quote.save
          #quote.date = Time.parse(release[6])

          #puts release.inspect
        end
    end
    
  end



  #doc.search('//b[text()="Earnings Releases"]')
  #element = #doc.search('//b[text()="Earnings Releases"]')
  #element.parent.parent.parent.next.next >> to locate the right table in the page
  #doc.search('h3.r a.l', '//h3/a').each do |link|
    #puts link.content

# rows.each do |row|
#   release = row.search("td").map do |td|
#     td.text
#   end
#   puts release.inspect
# end

end
