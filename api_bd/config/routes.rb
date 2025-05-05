# Rails.application.routes.draw do
#   namespace :api, defaults: { format: 'json' } do
#     namespace :v1 do
#       post 'login', to: 'sessions#create'
#       delete 'logout', to: 'sessions#destroy'
      
#       resources :usuarios do
#         resources :temas, shallow: true do
#           resources :notas, shallow: true
#         end
#       end
#     end
#   end
# end

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      resources :usuarios, only: [:create]
      
      # Rutas que requieren autenticación
      resources :usuarios, except: [:create] do
        resources :temas, shallow: true do
          resources :notas, shallow: true
        end
      end
    end
  end
end
