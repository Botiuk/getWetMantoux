# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can %i[read contacts], :home
    can %i[read belonging_doctors], Speciality
    can :read, Doctor

    return if user.blank?

    can %i[read create update], PersonalCard, user_id: user.id
    can %i[read create destroy], Review, user_id: user.id
    can :medical_card, Review

    if user.doctor_on_contract?
      can :read, Review
      can :update, Review, doctor_id: user.doctor.id
      can :update, Doctor, user_id: user.id
    end

    return unless user.admin?

    can %i[read create update], Speciality
    can %i[read create update], Doctor
    can %i[read update search], PersonalCard
    can :index, Review
    can %i[read update search], User
  end
end
