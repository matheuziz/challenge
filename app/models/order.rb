class Order < ApplicationRecord
    monetize :total_value_cents
    enum status: [:ready, :production, :closing, :sent]

end
