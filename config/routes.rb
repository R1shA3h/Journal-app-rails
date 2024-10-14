Rails.application.routes.draw do
  resources :notes, except: [:index] do
    post 'share', on: :member
  end

  get 'shared_notes', to: 'notes#shared_notes'

  devise_for :user,
  controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'home#index' #root  = localhost:3000
end
