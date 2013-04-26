class StocksController < ApplicationController
  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }
    end
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
    @stock = Stock.find(params[:id])
    @quote_with_dates = @stock.quotes.where(['date is not null'])     
    @stock.history_percent #this seems to call the function correctly


    @up_history_predictions = @stock.quotes.where(:history_prediction => 'Up')
    up_prediction_wins = @up_history_predictions.where(:history_win => true)
    @up_win_percent = ((up_prediction_wins.size.to_f / @up_history_predictions.size.to_f)*100).round(2)


    @down_history_predictions = @stock.quotes.where(:history_prediction => 'Down')
    down_prediction_wins = @down_history_predictions.where(:history_win => true)
    @down_win_percent = ((down_prediction_wins.size.to_f / @down_history_predictions.size.to_f)*100).round(2)

    #sent to view, only shows quotes that have a date, and in the past - 18 of them...
    @past_quotes = @quote_with_dates.where('date < ?', Date.today).limit(18)
    @future_quote = @quote_with_dates.where('date > ?', Date.today)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stock }
    end
  end

  def dashboard
    @winning_stocks = Stock.winning
    @losing_stocks = Stock.losing 

    @next_winners = @winning_stocks.each do |stock|
      quote_with_date = stock.quotes.where(['date is not null'])    
      @future_quotes_of_winning_stocks = quote_with_date.where('date > ?', Date.today)          
    end 

    @stock_order = @winning_stocks.all_ordered_by_child
  end
  #This works - why can't I access the .date from the view

  # GET /stocks/new
  # GET /stocks/new.json
  def new
    @stock = Stock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stock }
    end
  end

  # GET /stocks/1/edit
  def edit
    @stock = Stock.find(params[:id])
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(params[:stock])

    respond_to do |format|
      if @stock.save
        Quote.grab_data(@stock.symbol)
        format.html { redirect_to @stock, notice: 'Stock was successfully created.' }
        format.json { render json: @stock, status: :created, location: @stock }
      else
        format.html { render action: "new" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stocks/1
  # PUT /stocks/1.json
  def update
    @stock = Stock.find(params[:id])

    respond_to do |format|
      if @stock.update_attributes(params[:stock])
        format.html { redirect_to @stock, notice: 'Stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end
end


