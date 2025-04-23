Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :usuarios do
        resources :temas, shallow: true do
          resources :notas, shallow: true
        end
      end
    end
  end
end
