require 'nokogiri'
require 'open-uri'

class Quote < ActiveRecord::Base
  attr_accessible :date, :eps_actual, :eps_estimate, :neg1_close, :neg1_open, :stock_id, :time, :zero_close, :zero_open
  belongs_to :stock



  # def lookup(symbol, date)
  #     YahooFinance::get_historical_quotes( symbol,
  #                                     date,
  #                                     date ) do |row|
              
  #             self.zero_open = row[1]
  #             self.zero_close = row[4]        
  #       end
  # end
  def self.get 
    doc = Nokogiri::HTML(open("http://www.earnings.com/company.asp?client=cb&ticker=aig")){|c|c.options = Nokogiri::XML::ParseOptions::NOBLANKS}
    element = doc.search('//b[text()="Earnings Releases"]')
    table = element.parent.parent.parent.next#.next >>take out this next because we are skipping blanks which is the {code} following our 'doc' assignment.
    rows = table.search("tr")

    rows.each do |row|
        release = row.search("td").map do |td|
            td.text
        end
        quote = Quote.new
        quote.date = Time.parse(release[6])
        #puts release.inspect
    end


    
  end

end

  #doc.search('//b[text()="Earnings Releases"]')
  #element = #doc.search('//b[text()="Earnings Releases"]')
  #element.parent.parent.parent.next.next >> to locate the right table in the page
  #doc.search('h3.r a.l', '//h3/a').each do |link|
    #puts link.content


end
