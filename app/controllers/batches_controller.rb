class BatchesController < ApplicationController
  def create
    batch = Batch.new(purchase_channel: params['purchase_channel'])
    if batch.save
      render json: {
        batch: { reference: batch.reference, orders: batch.orders.count }
      },
             status: :created
    else
      render json: { errors: batch.errors }, status: :unprocessable_entity
    end
  end

  def produce
    batch = Batch.find_by(reference: params['reference'])
    if batch.nil?
      render json: { errors: { batch: 'not found' } },
             status: :not_found
    else
      count = batch.produce
      render json: { batch: { produced: count } }, status: :ok
    end
  end

  def close
    batch = Batch.find_by(reference: params['reference'])
    if batch.nil?
      render json: { errors: { batch: 'not found' } },
             status: :not_found
    else
      count = batch.close(params['delivery_service'])
      render json: { batch: { closed: count } }, status: :ok
    end
  end
end
