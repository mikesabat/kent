class AddDateTextToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :date_text, :text
  end
end
