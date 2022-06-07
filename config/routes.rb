Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:create] do
    collection do
      post :login
    end
  end
  post 'upload', to: 'images#upload'
end
