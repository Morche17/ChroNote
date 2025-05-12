class RemoveFechaCreacionFromNota < ActiveRecord::Migration[8.0]
  def change
    remove_column :nota, :fecha_creacion, :datetime
  end
end
