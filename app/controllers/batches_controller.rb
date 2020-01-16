class BatchesController < ApplicationController
  def create
    batch = Batch.new(purchase_channel: params['purchase_channel'])
    if batch.save
      render json: { reference: batch.reference, orders: batch.orders.count },
             status: :created
    else
      render json: { errors: batch.errors }, status: :unprocessable_entity
    end
  end

  def produce
    Batch.find_by(reference: params['reference']).produce
    head :ok, type: 'application/json'
  end

  def close
    count = Batch.find_by(reference: params['reference'])
                 .close(params['delivery_service'])
    render json: { closed_orders: count }, status: :ok
  end
end
