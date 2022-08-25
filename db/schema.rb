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

ActiveRecord::Schema.define(version: 2022_08_25_041552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emitters", force: :cascade do |t|
    t.string "name", null: false
    t.string "rfc", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true, null: false
    t.index ["rfc"], name: "unique_emitter_rfc", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.string "uuid", null: false
    t.boolean "active", default: true, null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "currency", null: false
    t.date "emitted_at", null: false
    t.date "expires_at", null: false
    t.date "signed_at", null: false
    t.text "cfdi_digital_stamp", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "receiver_id", null: false
    t.bigint "emitter_id", null: false
  end

  create_table "receivers", force: :cascade do |t|
    t.string "name", null: false
    t.string "rfc", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true, null: false
    t.index ["rfc"], name: "unique_receiver_rfc", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "invoices", "emitters", name: "emitter_id_on_invoices"
  add_foreign_key "invoices", "receivers", name: "receive_id_on_invoices"
  add_foreign_key "invoices", "users", name: "user_id_on_invoices"
end
