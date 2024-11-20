# frozen_string_literal: true

class CreatePersonalCards < ActiveRecord::Migration[7.1]
  def change
    create_table :personal_cards do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
