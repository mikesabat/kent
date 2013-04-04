class AddPeriodToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :period, :text
  end
end
