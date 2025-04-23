# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_23_022919) do
  create_table "nota", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "tema_id", null: false
    t.string "nombre"
    t.string "descripcion"
    t.datetime "fecha_creacion"
    t.date "fecha_notificacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tema_id"], name: "index_nota_on_tema_id"
  end

  create_table "temas", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.string "nombre"
    t.boolean "posee_calendario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_temas_on_usuario_id"
  end

  create_table "usuarios", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "nombre"
    t.string "correo"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["correo"], name: "index_usuarios_on_correo", unique: true
  end

  add_foreign_key "nota", "temas"
  add_foreign_key "temas", "usuarios"
end
