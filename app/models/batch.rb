class Batch < ApplicationRecord
  has_many :orders
  validates :purchase_channel, presence: true
  before_create :set_reference, :set_orders

  def produce
    orders.production.update_all(status: :closing)
  end

  def close(delivery_service)
    orders.closing.where(delivery_service: delivery_service)
          .update_all(status: :sent)
  end

  private

  def set_reference
    self.reference = SecureRandom.uuid.first 11
  end

  def set_orders
    orders = Order.ready.where(purchase_channel: purchase_channel)
    orders.each { |order| order.status = :production }
    self.orders << orders
  end
end
