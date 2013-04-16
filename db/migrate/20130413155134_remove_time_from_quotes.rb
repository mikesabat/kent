class RemoveTimeFromQuotes < ActiveRecord::Migration
  def up
    remove_column :quotes, :time
      end

  def down
    add_column :quotes, :time, :string
  end
end
