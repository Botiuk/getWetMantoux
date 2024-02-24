class Speciality < ApplicationRecord
    has_many :doctors, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    def self.formhelper
        Speciality.pluck(:name, :id)
    end

end
