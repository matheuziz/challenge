Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :orders do
    post 'create', to: 'orders#create'
    get 'status/reference/:reference', to: 'orders#reference_status'
    get 'status/client/:client_name', to: 'orders#client_status'
    get 'list/:purchase_channel', to: 'orders#list'
  end

  scope :batches do
    post 'create/:purchase_channel', to: 'batches#create'
    post 'produce/:reference', to: 'batches#produce'
    post 'close/:reference/:delivery_service', to: 'batches#close'
  end
end
