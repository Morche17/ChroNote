module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: [:create]
  end

  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    
    begin
      decoded = JWT.decode(
        token, 
        Rails.application.credentials.secret_key_base
      ).first
      @current_user = Usuario.find(decoded['usuario_id'])
    rescue
      render json: { error: 'No autorizado' }, status: :unauthorized
    end
  end
end
