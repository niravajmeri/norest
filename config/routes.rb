Norest::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "home" => "home#index", :as => "home"
  get "original" => "home#original", :as => "original"
  get "pattern1" => "home#pattern1", :as => "pattern1"
  get "pattern2" => "home#pattern2", :as => "pattern2"
  get "pattern3" => "home#pattern3", :as => "pattern3"


  post "verify_requirements" => "home#verify_requirements", :as => "verify_requirements"

  get "norm_refinement" => "home#norm_refinement", :as => "norm_refinement"
  post "execute_norm_refinement" => "home#execute_norm_refinement", :as => "execute_norm_refinement"

  get "custom_norms" => "home#custom_norms", :as => "custom_norms"
  post "execute_custom_norms" => "home#execute_custom_norms", :as => "execute_custom_norms"

  get "custom" => "home#custom", :as => "custom"
  post "execute_nusmv" => "home#execute_nusmv", :as => "execute_nusmv"
  
  # You can have the root of your site routed with "root"
  root 'home#index'

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
