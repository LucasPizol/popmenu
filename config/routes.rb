Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :restaurants, only: [ :index, :show, :create, :update, :destroy ] do
        resources :menus, only: [ :index, :show ] do
          resources :menu_items, only: [ :index ]
        end
      end

      resources :menu_imports, only: [:create], defaults: { format: :multipart_form }
    end
  end
end
