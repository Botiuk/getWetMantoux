class PersonalCard < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :date_of_birth, presence: true

  validates_each :last_name, :first_name, :middle_name do |record, attr, value|
    record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
  end

  default_scope { order(:last_name, :first_name, :middle_name, :date_of_birth) }

end
