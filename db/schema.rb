# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_812_142_634) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'contacts', force: :cascade do |t|
    t.uuid 'uuid', default: -> { 'gen_random_uuid()' }, null: false
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.string 'email', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'deleted', default: false
    t.index ['email'], name: 'index_contacts_on_email'
    t.index ['first_name'], name: 'index_contacts_on_first_name'
    t.index ['last_name'], name: 'index_contacts_on_last_name'
    t.index ['uuid'], name: 'index_contacts_on_uuid'
  end

  create_table 'contacts_tags', id: false, force: :cascade do |t|
    t.bigint 'contact_id', null: false
    t.bigint 'tag_id', null: false
    t.index %w[contact_id tag_id], name: 'index_contacts_tags_on_contact_id_and_tag_id'
    t.index %w[tag_id contact_id], name: 'index_contacts_tags_on_tag_id_and_contact_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.uuid 'uuid', default: -> { 'gen_random_uuid()' }, null: false
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_tags_on_name'
    t.index ['uuid'], name: 'index_tags_on_uuid'
  end
end
