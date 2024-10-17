Rails.application.routes.draw do
  # Routes for User authentication
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  resources :notes_permissions, only: [ :index, :destroy, :update_permission ]
  # Nested routes for notes
  resources :notes, except: [ :index ] do
    member do
      post "share"  # Route for sharing a note
    end
  end

  # Route for viewing all shared notes
  get "shared_notes", to: "notes_permissions#index", as: "shared_notes" # Use appropriate controller

  # Root route
  root "home#index"  # Redirect to the home page
end
