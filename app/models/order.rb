class Order < ApplicationRecord
  belongs_to :batch, optional: true
  enum status: %i[ready production closing sent]
end
