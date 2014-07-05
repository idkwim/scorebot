Scorebot::Application.routes.draw do
  resources :tickets do
    member do
      post :resolve
      post :unresolve
    end
  end

  get "scoreboard", to: 'scoreboard#index', as: 'scoreboard'
  get "dashboard", to: 'dashboard#index', as: 'dashboard'
  get "howto", to: "high_voltage/pages#show", id: 'howto', as: 'howto'

  post "redeem", to: 'redemption#create', as: 'redemption'

  get 'timers', to: 'timers#index', as: 'timers'

  root to: redirect('/dashboard')
end
