class AddHistoryWinPercentageToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :history_win_percentage, :decimal
  end
end
