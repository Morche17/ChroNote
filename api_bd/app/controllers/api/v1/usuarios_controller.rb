class Api::V1::UsuariosController < ApplicationController
  before_action :set_usuario, only: %i[ show update destroy ]

  # GET /usuarios
  def index
    @usuarios = Usuario.all

    # render json: @usuarios
  end

  # GET /usuarios/1
  def show
    # render json: @usuario
    # render :show
  end

  # POST /usuarios
  def create
    @usuario = Usuario.new(usuario_params)

    if @usuario.save
      render json: @usuario, status: :created, location: @usuario
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /usuarios/1
  def update
    if @usuario.update(usuario_params)
      render json: @usuario
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  # DELETE /usuarios/1
  def destroy
    @usuario.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def usuario_params
      user_params = params.require(:usuario).permit(:nombre, :correo, :contrasena)
      user_params[:password] = user_params.delete(:contrasena) if user_params[:contrasena]
      user_params
    end
end
