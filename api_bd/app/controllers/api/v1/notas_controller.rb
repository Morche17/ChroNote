module Api::V1
  class NotasController < ApplicationController
    before_action :set_tema
    before_action :set_nota, only: [:show, :update, :destroy]

    # GET /api/v1/temas/:tema_id/notas
    def index
      @notas = @tema.notas
      render json: @notas
    end

    # GET /api/v1/temas/:tema_id/notas/1
    def show
      render json: @nota
    end

    # POST /api/v1/temas/:tema_id/notas
    def create
      @nota = @tema.notas.new(nota_params)

      if @nota.save
        render json: @nota, status: :created
      else
        render json: @nota.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/temas/:tema_id/notas/1
    def update
      if @nota.update(nota_params)
        render json: @nota
      else
        render json: @nota.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/temas/:tema_id/notas/1
    def destroy
      @nota.destroy
      head :no_content
    end

    private
      def set_tema
        @tema = Tema.find(params[:tema_id])
      end

      def set_nota
        @nota = @tema.notas.find(params[:id])
      end

      def nota_params
        params.require(:nota).permit(:nombre, :descripcion, :fecha_notificacion)
      end
  end
end
