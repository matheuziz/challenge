Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :orders do
    post 'create', to: 'orders#create'
    get 'status/:identifier', to: 'orders#status', defaults: { reference: true }
  end
end
