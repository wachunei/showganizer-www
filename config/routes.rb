S0::Application.routes.draw do
  resources :watchlists

  # Movies
  resources :movies

  # Series
  resources :serials, path: "/series" do
    resources :seasons do
      resources :episodes
    end
  end
  
  # Session Management
  resources :sessions, only: [:create, :new, :destroy]
  get "/login", to: "sessions#create", as: :log_in
  get "/logout", to: "sessions#destroy", as: :log_out
  get "/signup", to: "users#new", as: :sign_up
  match "/login", to: "sessions#create", via: :post

  # Pages
  get "403", to: "pages#no_access", as: :access_denied


  resources :users do
    resource :watchlists, path: "/watchlist"    
  end

  resources :users do
    resource :watcheds, path: "/watched"
  end


  # User
  # User shorthands
  get "/me", to: "users#me", as: :my_profile
  get "/me/shows", to:"followed_shows#shows", as: :my_shows
  get "/me/series", to:"followed_shows#serials", as: :my_serials
  get "/me/movies", to:"followed_shows#movies", as: :my_movies
  get "/me/watchlist", to:"watchlists#my_watchlist", as: :my_watchlist
   get "/me/watched", to:"watched#my_watched", as: :my_watched

  # User Watchlist
  resources :users do
    resource :watchlists, path: "/watchlist"
  end

  # User show management
  get "/series/:id/add", to:"serials#add", as: :add_serial
  get "/series/:id/remove", to:"serials#remove", as: :remove_serial
  get "/movies/:id/add", to:"movies#add", as: :add_movie
  get "/movies/:id/remove", to:"movies#remove", as: :remove_movie


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
