# frozen_string_literal: true

class CreateSpecialities < ActiveRecord::Migration[7.1]
  def change
    create_table :specialities do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :specialities, :name, unique: true
  end
end
