class Quote < ActiveRecord::Base
  attr_accessible :date, :eps_actual, :eps_estimate, :neg1_close, :neg1_open, :stock_id, :time, :zero_close, :zero_open
  belongs_to :stock
end
