Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :contacts, only: %i[create index update destroy]
    end
  end
end
