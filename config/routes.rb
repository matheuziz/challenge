Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :orders do
    post 'create',
         to: 'orders#create', as: 'create_order'
    get 'status/reference/:reference',
        to: 'orders#reference_status', as: 'order_reference_status'
    get 'status/client/:client_name',
        to: 'orders#client_status', as: 'order_client_status'
    get 'list/:purchase_channel',
        to: 'orders#list', as: 'order_list'
  end

  scope :batches do
    post 'create/:purchase_channel',
         to: 'batches#create', as: 'batch_create'
    post 'produce/:reference',
         to: 'batches#produce', as: 'batch_produce'
    post 'close/:reference/:delivery_service',
         to: 'batches#close', as: 'batch_close'
  end
end
