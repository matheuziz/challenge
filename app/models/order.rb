class Order < ApplicationRecord
  belongs_to :batch, optional: true
  monetize :total_value_cents
  enum status: %i[ready production closing sent]
end
