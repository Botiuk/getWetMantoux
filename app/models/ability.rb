# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    can :read, :home
    can [:read, :belonging_doctors], Speciality
    can :read, Doctor

    if user.present?
      can [:read, :create, :update], PersonalCard, user_id: user.id

      if user.user?
        can [:manage, :medical_card], Review, user_id: user.id
        cannot :update, Review
      end
  
      if user.doctor? && user.doctor.present? && user.doctor.working?
        can  [:read, :medical_card], Review
        can :update, Review, doctor_id: user.doctor.id
        can :update, Doctor, user_id: user.id
      end
  
      if user.admin?
        can :manage, Speciality
        can [:read, :create, :update], Doctor
        can [:read, :update], PersonalCard
        can :read, Review
      end

    end
  end
end
