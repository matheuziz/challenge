class OrdersController < ApplicationController
  def create
    order = Order.new(order_params)
    if order.save
      render json: { order: order }, status: :created
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

  def reference_status
    order = Order.find_by(reference: params['reference'])
    render_status order
  end

  # Returns only the last order for queries by client_name
  def client_status
    order = Order.last_by_client(params['client_name'])
    render_status order
  end

  def list
    render json: {
      orders: Order.where(purchase_channel: params['purchase_channel'])
    },
           status: :ok
  end

  private

  def order_params
    params.require(:order).permit(
      :reference, :purchase_channel, :client_name, :address,
      :delivery_service, :total_value, line_items: []
    )
  end

  def render_status(order)
    if order.nil?
      render json: { errors: { order: 'not found' } }, status: :not_found
    else
      render json: { order: { status: order.status } },
             status: :ok
    end
  end
end
