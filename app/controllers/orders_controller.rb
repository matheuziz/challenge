class OrdersController < ApplicationController

  # POST /orders/create
  def create
    order = Order.new(order_params)
    if order.save
      render json: { created_order: order }, status: :created
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

  # GET /orders/status/:identifier
  # search by reference or client_name
  # Returns only the last order for queries by client_name
  def status
    order = if params['client'] == 'true'
              Order.where(client_name: params['identifier'])
                   .order(created_at: :asc)
                   .last
            else
              Order.find_by(reference: params['identifier'])
            end
    render json: { status: order.status }, status: :ok
  end

  # GET /orders/list/:purchase_channel
  def list
    render json: Order.where(purchase_channel: params['purchase_channel']),
           status: :ok
  end

  private

  def order_params
    params.require(:order).permit(
      :reference, :purchase_channel, :client_name, :address,
      :delivery_service, :status, :total_value, line_items: []
    )
  end
end
