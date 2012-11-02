KobayshiMaru::Application.routes.draw do
  post '/loop' => 'games#loop'
  get '/games/leave' => 'games#leave'

  resources :games
  resource :player,
    only: [:update] do
      resources :messages,
        only: [:index]
      get 'touch' => 'players#touch', on: :member
  end
  resources :players, except: [:update] do
    post :challenge, on: :member
    post :accept   , on: :member
  end
  root :to => 'games#index'
end
