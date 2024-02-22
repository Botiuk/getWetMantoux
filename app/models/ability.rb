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
        can :manage, Review, user_id: user.id
      end
  
      if user.doctor?
        can :read, Review
        can :update, Review, doctor_id: user.doctor.id
      end
  
      if user.admin?
        can :manage, Speciality
        can :manage, Doctor
        can [:read, :update], PersonalCard
        can :read, Review
      end

    end
  end
end
