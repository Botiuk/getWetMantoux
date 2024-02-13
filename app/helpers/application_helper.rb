module ApplicationHelper

    def find_user_personal_card
        if user_signed_in?
            @card = PersonalCard.where(user_id: current_user.id)
            if @card.blank?
                redirect_to new_personal_card_url
            end
        end
    end

end
