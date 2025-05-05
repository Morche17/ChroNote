class Api::V1::SessionsController < ApplicationController
  def create
    usuario = Usuario.find_by(correo: params[:correo])
    
    if usuario&.authenticate(params[:password])
      render json: {
        usuario: usuario.as_json(only: [:id, :nombre, :correo]),
        token: generate_token(usuario)
      }, status: :ok
    else
      render json: { error: "Credenciales inválidas" }, status: :unauthorized
    end
  end

  private
  
  def generate_token(usuario)
    payload = { usuario_id: usuario.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
