Rails.application.routes.draw do
  resources :racers
  resources :races
  #add a nested resource to register a Racer for a Race from the racers#edit page. This is the nexted
  #entries rouces. Functionality will only be to a POST mapped to a create_entry action method within racers
  #controler
  resources :racers do
    post "entries" => "racers#create_entry"
  end

  #namespace api for use with api's
  namespace :api do
    resources :races, only: [:index, :show, :create, :update, :destroy] do
      resources :results, only: [:index,:show]
    end

    resources :racers, only: [:index, :show] do
      resources :entries, only: [:index, :show]
    end
  end


  #index" #to represent the collection of races
  #get "/api/races/:id" => "api/races#show" #to represent a specific race
  #get "/api/races/:race_id/results" => "api/races#index" #to represent all results for the specific race
  #get "/api/races/:race_id/results/:id" => "api/races_result#show" #to represent a specific results for the specific race

  #get "/api/racers" => "racers#index" #to represent the collection of racers
  #get "/api/racers/:id" => "racers#show" #to represent a specific racer
  #get "/api/racers/:racer_id/entries" => "racer_entries#index" #to represent a the collection of race entries for a specific racer
  #get "/api/racers/:racer_id/entries/:id" => "racer_entries#show" #to represent a specific race entry for a specific racer


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'races#index'

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
