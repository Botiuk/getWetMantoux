# frozen_string_literal: true

class AddPhoneToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone, :string
    add_index :users, :phone, unique: true
  end
end
