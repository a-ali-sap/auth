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

ActiveRecord::Schema[8.0].define(version: 2025_07_12_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "age_verifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "verification_method", null: false
    t.integer "verification_status", default: 0, null: false
    t.string "document"
    t.datetime "verified_at"
    t.bigint "verified_by_id"
    t.text "verification_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_birth"
    t.index ["user_id"], name: "index_age_verifications_on_user_id"
    t.index ["verification_method"], name: "index_age_verifications_on_verification_method"
    t.index ["verification_status"], name: "index_age_verifications_on_verification_status"
    t.index ["verified_by_id"], name: "index_age_verifications_on_verified_by_id"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "joined_at"
    t.text "join_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
    t.index ["role"], name: "index_organization_memberships_on_role"
    t.index ["status"], name: "index_organization_memberships_on_status"
    t.index ["user_id", "organization_id"], name: "index_organization_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_organization_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.integer "organization_type", null: false
    t.integer "status", default: 0
    t.boolean "is_public", default: true
    t.string "website_url"
    t.string "contact_email"
    t.string "phone_number"
    t.text "address"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_public"], name: "index_organizations_on_is_public"
    t.index ["name"], name: "index_organizations_on_name", unique: true
    t.index ["organization_type"], name: "index_organizations_on_organization_type"
    t.index ["owner_id"], name: "index_organizations_on_owner_id"
    t.index ["status"], name: "index_organizations_on_status"
  end

  create_table "parental_consents", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "participation_space_id", null: false
    t.string "parent_name", null: false
    t.string "parent_email", null: false
    t.string "parent_phone", null: false
    t.string "relationship", null: false
    t.integer "status", default: 0
    t.integer "consent_method", default: 0
    t.string "verification_code"
    t.datetime "consent_given_at"
    t.datetime "approved_at"
    t.datetime "expires_at"
    t.text "rejection_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_parental_consents_on_expires_at"
    t.index ["participation_space_id"], name: "index_parental_consents_on_participation_space_id"
    t.index ["status"], name: "index_parental_consents_on_status"
    t.index ["user_id", "participation_space_id"], name: "index_parental_consents_on_user_id_and_participation_space_id"
    t.index ["user_id"], name: "index_parental_consents_on_user_id"
  end

  create_table "participation_spaces", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.bigint "organization_id", null: false
    t.bigint "creator_id", null: false
    t.integer "participation_type", default: 0
    t.integer "status", default: 0
    t.integer "max_participants", null: false
    t.integer "current_participants", default: 0
    t.json "allowed_age_groups"
    t.json "content_filters"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_participation_spaces_on_creator_id"
    t.index ["organization_id"], name: "index_participation_spaces_on_organization_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "participation_space_id", null: false
    t.integer "status", default: 0
    t.datetime "joined_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "completed_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participation_space_id"], name: "index_participations_on_participation_space_id"
    t.index ["status"], name: "index_participations_on_status"
    t.index ["user_id", "participation_space_id"], name: "index_participations_on_user_id_and_participation_space_id", unique: true
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "date_of_birth", null: false
    t.string "phone_number"
    t.string "age_group"
    t.integer "status", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_group"], name: "index_users_on_age_group"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "age_verifications", "users"
  add_foreign_key "age_verifications", "users", column: "verified_by_id"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_memberships", "users"
  add_foreign_key "organizations", "users", column: "owner_id"
  add_foreign_key "parental_consents", "participation_spaces"
  add_foreign_key "parental_consents", "users"
  add_foreign_key "participation_spaces", "organizations"
  add_foreign_key "participation_spaces", "users", column: "creator_id"
  add_foreign_key "participations", "participation_spaces"
  add_foreign_key "participations", "users"
end
