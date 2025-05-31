class ChangeFechaNotificacionFromNotas < ActiveRecord::Migration[8.0]
  def change
    change_column :nota, :fecha_notificacion, :datetime
  end
end
