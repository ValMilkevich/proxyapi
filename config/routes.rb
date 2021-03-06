Prxapi::Application.routes.draw do

devise_for :users, :path => "",
  :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' },
  controllers: { omniauth_callbacks: "omniauth_callbacks", sessions: "sessions" }

root :to => "dashboard#show"
resource :dashboard, only: [:show]


namespace :admin do
  root :to => "dashboard#show"
  resources :miners
end

namespace :api do
  namespace :cmd do
    root :to => "messages#cmd"

    resources :messages
    get "messages/:name", :to => "messages#index"
  end
  resources :proxies, only: [:index, :show] do
    collection do
      get :fast
      get :recent
      get :random
      get :available
    end
  end

  resources :countries, only: [:index, :show] do
    scope :module => :countries do
      resources :proxies, only: [:index, :show]
    end
  end
end

get "api/proxies/selector/*selector", to: "api/proxies#selector"
get "api/test", to: "api#test"

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
