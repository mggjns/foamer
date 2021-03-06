Foamer::Application.routes.draw do

  resources :calendars

  root :to => "static_pages#signin"
  
  get "/signin" => "static_pages#signin", :as => :signin
  get "/welcome" => "static_pages#welcome", :as => :welcome

  get "/home" => "events#home", :as => :home
  match "/refresh" => "events#refresh", :as => :refresh_events
  get "/got_nothing" => "events#got_nothing", :as => :got_nothing
  get "/event_review" => "events#event_review", :as => :event_review
  get "/travel_mode" => "events#travel_mode", :as => :travelmode

  resources :events
  resources :places
  resources :users

  get '/calendar_review' => 'calendars#calendar_review', :as => :calendar_review
  
  match '/auth/failure' => 'sessions#failure'
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/authenticate' => 'sessions#new', :as => :authenticate
  match '/auth/:provider/callback' => 'sessions#create'

  # pagination for stepping through events
  get "/home/:page" => "events#home"




  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
