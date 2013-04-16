class AddHistoryPredictionAndHistoryWinToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :history_prediction, :string
    add_column :quotes, :history_win, :boolean
  end
end
