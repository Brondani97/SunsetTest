# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # para desarrollo; en producción restringe al dominio de tu frontend
    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end
