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

ActiveRecord::Schema[8.0].define(version: 2025_10_30_080538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "certificates", force: :cascade do |t|
    t.string "certificate_cid"
    t.string "uploader_wallet"
    t.jsonb "parsed_json"
    t.float "hectares"
    t.string "location_text"
    t.jsonb "geo"
    t.string "status"
    t.float "confidence"
    t.string "metadata_cid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "unsigned_tx"
    t.string "blockchain_batch_id"
  end

  create_table "token_batches", force: :cascade do |t|
    t.bigint "batch_id"
    t.bigint "certificate_id", null: false
    t.string "issuer_wallet"
    t.integer "total_tokens"
    t.integer "tokens_per_hectare"
    t.string "metadata_cid"
    t.string "minted_tx_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_id"], name: "index_token_batches_on_certificate_id"
  end

  add_foreign_key "token_batches", "certificates"
end
