# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    can [:read, :contacts], :home
    can [:read, :belonging_doctors], Speciality
    can :read, Doctor

    if user.present?
      can [:read, :create, :update], PersonalCard, user_id: user.id
      can [:read, :create, :destroy], Review, user_id: user.id
      can :medical_card, Review

      if user.doctor_on_contract?
        can :read, Review
        can :update, Review, doctor_id: user.doctor.id
        can :update, Doctor, user_id: user.id
      end

      if user.admin?
        can [:read, :create, :update], Speciality
        can [:read, :create, :update], Doctor
        can [:read, :update, :search], PersonalCard
        can :index, Review
        can [:read, :update], User
      end

    end
  end
end
