class OrdersController < ApplicationController

  # POST /orders/create
  def create
    order = Order.new(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: order.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :reference, :purchase_channel, :client_name, :address,
      :delivery_service, :status, :total_value, line_items: []
    )
  end
end
