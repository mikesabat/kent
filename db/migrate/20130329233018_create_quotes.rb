class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :stock_id
      t.decimal :neg1_open
      t.decimal :neg1_close
      t.decimal :zero_open
      t.decimal :zero_close
      t.date :date
      t.string :time
      t.decimal :eps_estimate
      t.decimal :eps_actual

      t.timestamps
    end
  end
end
