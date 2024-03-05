Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  scope '/admin' do
    resources :users
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'specialities/belonging_doctors', to: 'specialities#belonging_doctors'
  get 'reviews/medical_card', to: 'reviews#medical_card'
  get 'contacts', to: 'home#contacts'
  get 'personal_cards/search', to: 'personal_cards#search'

  resources :personal_cards, :specialities, :doctors, :reviews

  root "home#index"
end
