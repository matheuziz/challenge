class Order < ApplicationRecord
  belongs_to :batch, optional: true
  enum status: %i[ready production closing sent]
  validates :reference, :purchase_channel, :client_name, :address,
            :delivery_service, :total_value, :line_items, presence: true

  def self.last_by_client(client_name)
    where(client_name: client_name)
      .order(created_at: :asc)
      .last
  end
end
