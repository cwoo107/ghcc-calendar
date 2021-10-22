Rails.application.routes.draw do
  resources :events
  get :list_events, to: 'events#list'
  get :featured_event_slides, to: 'events#slides'

  resources :welcome

  root 'events#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
