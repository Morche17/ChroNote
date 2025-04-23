class CreateTemas < ActiveRecord::Migration[8.0]
  def change
    create_table :temas do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :nombre
      t.boolean :posee_calendario

      t.timestamps
    end
  end
end
