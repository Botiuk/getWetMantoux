class Speciality < ApplicationRecord
    has_many :doctors, dependent: :destroy

    validates :name, presence: true, uniqueness: true

    validates_each :name, :description do |record, attr, value|
        record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
    end

    def self.formhelper
        Speciality.order(:name).pluck(:name, :id)
    end

end
