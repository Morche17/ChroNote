class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :correo
      t.string :contrasena

      t.timestamps
    end

    add_index :usuarios, :correo, unique: true
  end
end
