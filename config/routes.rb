Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:create] do
    collection do
      post :login
    end
  end

  resources :urls, only: [:create]
end
