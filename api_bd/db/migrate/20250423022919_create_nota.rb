class CreateNota < ActiveRecord::Migration[8.0]
  def change
    create_table :nota do |t|
      t.references :tema, null: false, foreign_key: true
      t.string :nombre
      t.string :descripcion
      t.datetime :fecha_creacion
      t.date :fecha_notificacion

      t.timestamps
    end
  end
end
