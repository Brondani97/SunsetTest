Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :day_records, only: [:index]
    end
  end

  # root "posts#index"
end
