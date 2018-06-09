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

ActiveRecord::Schema.define(version: 2018_06_09_183538) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "audio_bibles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "short_name"
    t.integer "lang", limit: 1
    t.integer "record_type", limit: 1, default: 1, null: false
    t.text "remark"
    t.integer "rank"
    t.bigint "group_id"
    t.bigint "user_id"
    t.integer "auth", limit: 1, default: 1, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_audio_bibles_on_code", unique: true
    t.index ["group_id"], name: "index_audio_bibles_on_group_id"
    t.index ["user_id"], name: "index_audio_bibles_on_user_id"
  end

  create_table "audio_segments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "audio_bible_id"
    t.integer "book_code", limit: 2, null: false
    t.integer "chapter", limit: 2, null: false
    t.integer "verse", limit: 2, null: false
    t.float "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["audio_bible_id"], name: "index_audio_segments_on_audio_bible_id"
  end

  create_table "bible_books", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.integer "book_code", limit: 2, null: false
    t.string "book_name"
    t.index ["bible_id", "book_code"], name: "index_bible_books_on_bible_id_and_book_code", unique: true
    t.index ["bible_id"], name: "index_bible_books_on_bible_id"
  end

  create_table "bibles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "short_name"
    t.integer "lang", limit: 1
    t.integer "module_type", limit: 1, default: 1, null: false
    t.integer "rank"
    t.bigint "group_id"
    t.bigint "user_id"
    t.integer "auth", limit: 1, default: 1, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_bibles_on_code", unique: true
    t.index ["group_id"], name: "index_bibles_on_group_id"
    t.index ["user_id"], name: "index_bibles_on_user_id"
  end

  create_table "dictionaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "short_name"
    t.integer "lang", limit: 1
    t.integer "module_type", limit: 1, default: 2, null: false
    t.integer "rank"
    t.bigint "group_id"
    t.bigint "user_id"
    t.integer "auth", limit: 1, default: 1, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_dictionaries_on_code", unique: true
    t.index ["group_id"], name: "index_dictionaries_on_group_id"
    t.index ["user_id"], name: "index_dictionaries_on_user_id"
  end

  create_table "group_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.integer "member_type", limit: 1, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", limit: 16, null: false
    t.string "name"
    t.integer "group_type", limit: 1, default: 1, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_groups_on_code", unique: true
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "morph_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "morphology_id", null: false
    t.string "parsing", null: false
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["morphology_id"], name: "index_morph_codes_on_morphology_id"
  end

  create_table "morphologies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.string "short_name"
    t.integer "lang", limit: 1
    t.integer "module_type", limit: 1, default: 2, null: false
    t.integer "rank"
    t.bigint "group_id"
    t.bigint "user_id"
    t.integer "auth", limit: 1, default: 1, null: false
    t.boolean "hidden", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_morphologies_on_code", unique: true
    t.index ["group_id"], name: "index_morphologies_on_group_id"
    t.index ["user_id"], name: "index_morphologies_on_user_id"
  end

  create_table "used_bibles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bible_id", null: false
    t.index ["bible_id"], name: "index_used_bibles_on_bible_id"
    t.index ["user_id", "bible_id"], name: "index_used_bibles_on_user_id_and_bible_id", unique: true
    t.index ["user_id"], name: "index_used_bibles_on_user_id"
  end

  create_table "used_langs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "lang", limit: 1
    t.index ["user_id", "lang"], name: "index_used_langs_on_user_id_and_lang", unique: true
    t.index ["user_id"], name: "index_used_langs_on_user_id"
  end

  create_table "user_props", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "key", limit: 1, null: false
    t.string "value"
    t.integer "auth", limit: 1, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "key"], name: "index_user_props_on_user_id_and_key", unique: true
    t.index ["user_id"], name: "index_user_props_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname", default: "", null: false
    t.string "code"
    t.integer "lang", limit: 1
    t.integer "sex", limit: 1, default: 1, null: false
    t.date "birthday"
    t.index ["code"], name: "index_users_on_code", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "vocab_counts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.integer "book_code", limit: 2, null: false
    t.string "lemma"
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id", "book_code", "lemma"], name: "index_vocab_counts_on_bible_id_and_book_code_and_lemma", unique: true
    t.index ["bible_id"], name: "index_vocab_counts_on_bible_id"
  end

  create_table "vocab_indices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "vocab_count_id", null: false
    t.integer "chapter", limit: 2, null: false
    t.integer "verse", limit: 2, null: false
    t.integer "count", limit: 1, default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vocab_count_id", "chapter", "verse"], name: "index_vocab_indices_on_vocab_count_id_and_chapter_and_verse", unique: true
    t.index ["vocab_count_id"], name: "index_vocab_indices_on_vocab_count_id"
  end

  create_table "vocabularies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "dictionary_id", null: false
    t.string "spell", null: false
    t.string "lemma", null: false
    t.text "meaning"
    t.string "outline"
    t.string "pronunciation"
    t.string "transliteration"
    t.string "etymology"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dictionary_id"], name: "index_vocabularies_on_dictionary_id"
  end

  add_foreign_key "audio_bibles", "groups"
  add_foreign_key "audio_bibles", "users"
  add_foreign_key "audio_segments", "audio_bibles"
  add_foreign_key "bible_books", "bibles"
  add_foreign_key "bibles", "groups"
  add_foreign_key "bibles", "users"
  add_foreign_key "dictionaries", "groups"
  add_foreign_key "dictionaries", "users"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "morph_codes", "morphologies"
  add_foreign_key "morphologies", "groups"
  add_foreign_key "morphologies", "users"
  add_foreign_key "used_bibles", "bibles"
  add_foreign_key "used_bibles", "users"
  add_foreign_key "used_langs", "users"
  add_foreign_key "user_props", "users"
  add_foreign_key "vocab_counts", "bibles"
  add_foreign_key "vocab_indices", "vocab_counts"
  add_foreign_key "vocabularies", "dictionaries"
end
