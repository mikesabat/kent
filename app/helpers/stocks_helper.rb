module StocksHelper
	
	def next_quote_date
		unless @future_quote.empty?
			puts "Has a Future Quote"
		end

	end

	def okok
		concat("<div>")
  	html = "<p> hello there! <p>"
  	concat("</div>")
	end
end
