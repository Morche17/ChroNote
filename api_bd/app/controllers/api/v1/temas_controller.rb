module Api::V1
  class TemasController < ApplicationController
    before_action :set_usuario
    before_action :set_tema, only: [:show, :update, :destroy]

    # GET /api/v1/usuarios/:usuario_id/temas
    def index
      @temas = @usuario.temas
      render json: @temas
    end

    # GET /api/v1/usuarios/:usuario_id/temas/1
    def show
      render json: @tema
    end

    # POST /api/v1/usuarios/:usuario_id/temas
    def create
      @tema = @usuario.temas.new(tema_params)

      if @tema.save
        render json: @tema, status: :created
      else
        render json: @tema.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/usuarios/:usuario_id/temas/1
    def update
      if @tema.update(tema_params)
        render json: @tema
      else
        render json: @tema.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/usuarios/:usuario_id/temas/1
    def destroy
      @tema.destroy
      head :no_content
    end

    private
      def set_usuario
        @usuario = Usuario.find(params[:usuario_id])
      end

      def set_tema
        @tema = @usuario.temas.find(params[:id])
      end

      def tema_params
        params.require(:tema).permit(:nombre, :posee_calendario)
      end
  end
end
