class Speciality < ApplicationRecord
    has_many :doctors

    validates :name, presence: true, uniqueness: true

    validates_each :name, :description do |record, attr, value|
        record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
    end

    default_scope { order(:name) }

    def self.formhelper
        Speciality.pluck(:name, :id)
    end

end
