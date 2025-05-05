Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # En producción cambiar por el dominio de Flutter
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
