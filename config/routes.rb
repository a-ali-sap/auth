Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  # Public root for unauthenticated users
  unauthenticated :user do
    root 'home#index', as: :unauthenticated_root
  end
  
  # Authenticated root
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end
  
  # Fallback root
  root 'dashboard#index'
  
  # Organization routes
  resources :organizations do
    member do
      post :join
      delete :leave
      get :analytics
    end
    

    resources :memberships, controller: 'organization_memberships', only: [:index, :show, :create, :update, :destroy] do
      member do
        patch :update_role
        patch :approve
        patch :reject
      end
    end
    
    resources :participation_spaces do
      resources :participations, only: [:create, :destroy]
    end
  end
  
  # Age verification routes
  resources :age_verifications, only: [:new, :create, :show, :update]
  resources :parental_consents, only: [:new, :create, :show, :update]
  
  # Admin routes
  namespace :admin do
    resources :organizations
    resources :users
    resources :age_groups
    root 'dashboard#index'
  end
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :organizations, only: [:index, :show]
      resources :participation_spaces, only: [:index, :show]
    end
  end
end
