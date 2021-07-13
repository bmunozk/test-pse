Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :routes, only: :index do
    collection do
      get ':from', to: 'routes#show'
      get ':from/:to', to: 'routes#show'
      get ':from/:to/:airline', to: 'routes#show' #adding the new requiriment route 
    end
  end
end
