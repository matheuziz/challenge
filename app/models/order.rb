class Order < ApplicationRecord
    belongs_to :batch, optional: true
    monetize :total_value_cents
    enum status: [:ready, :production, :closing, :sent]

end
