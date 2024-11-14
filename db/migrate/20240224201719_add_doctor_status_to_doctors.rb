# frozen_string_literal: true

class AddDoctorStatusToDoctors < ActiveRecord::Migration[7.1]
  def change
    add_column :doctors, :doctor_status, :integer, null: false, default: 0
  end
end
