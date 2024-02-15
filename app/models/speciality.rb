class Speciality < ApplicationRecord
    has_many :doctors, dependent: :destroy

    validates :name, presence: true

    def self.formhelper
        Speciality.pluck(:name, :id)
    end

end
