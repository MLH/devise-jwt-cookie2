# frozen_string_literal: true

class InitialiseSchemaFromDeviseJwtFixtures < ActiveRecord::Migration[7.2]
  def change
    create_table 'allowlisted_jwts', force: :cascade do |t|
      t.string 'jti', null: false
      t.string 'aud'
      t.integer 'jwt_with_allowlist_user_id'
      t.datetime 'exp', default: '2017-12-11 11:49:00', null: false
      t.index ['jti'], name: 'index_allowlisted_jwts_on_jti', unique: true
      t.index ['jwt_with_allowlist_user_id'], name: 'index_allowlisted_jwts_on_jwt_with_allowlist_user_id'
    end

    create_table 'jwt_denylist', force: :cascade do |t|
      t.string 'jti', null: false
      t.datetime 'exp', default: '2017-12-11 09:46:10', null: false
      t.index ['jti'], name: 'index_jwt_denylist_on_jti', unique: true
    end

    create_table 'jwt_with_allowlist_users', force: :cascade do |t|
      t.string 'email', default: '', null: false
      t.string 'encrypted_password', default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['email'], name: 'index_jwt_with_allowlist_users_on_email', unique: true
      t.index ['reset_password_token'], name: 'index_jwt_with_allowlist_users_on_reset_password_token', unique: true
    end

    create_table 'jwt_with_denylist_users', force: :cascade do |t|
      t.string 'email', default: '', null: false
      t.string 'encrypted_password', default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['email'], name: 'index_jwt_with_denylist_users_on_email', unique: true
      t.index ['reset_password_token'], name: 'index_jwt_with_denylist_users_on_reset_password_token', unique: true
    end

    create_table 'jwt_with_jti_matcher_users', force: :cascade do |t|
      t.string 'email', default: '', null: false
      t.string 'encrypted_password', default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'jti', null: false
      t.index ['email'], name: 'index_jwt_with_jti_matcher_users_on_email', unique: true
      t.index ['reset_password_token'], name: 'index_jwt_with_jti_matcher_users_on_reset_password_token', unique: true
    end

    create_table 'jwt_with_null_users', force: :cascade do |t|
      t.string 'email', default: '', null: false
      t.string 'encrypted_password', default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['email'], name: 'index_jwt_with_null_users_on_email', unique: true
      t.index ['reset_password_token'], name: 'index_jwt_with_null_users_on_reset_password_token', unique: true
    end

    create_table 'no_jwt_users', force: :cascade do |t|
      t.string 'email', default: '', null: false
      t.string 'encrypted_password', default: '', null: false
      t.string 'reset_password_token'
      t.datetime 'reset_password_sent_at'
      t.datetime 'remember_created_at'
      t.integer 'sign_in_count', default: 0, null: false
      t.datetime 'current_sign_in_at'
      t.datetime 'last_sign_in_at'
      t.string 'current_sign_in_ip'
      t.string 'last_sign_in_ip'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['email'], name: 'index_no_jwt_users_on_email', unique: true
      t.index ['reset_password_token'], name: 'index_no_jwt_users_on_reset_password_token', unique: true
    end

    add_foreign_key 'allowlisted_jwts', 'jwt_with_allowlist_users'
  end
end
