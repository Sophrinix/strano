Strano::Application.routes.draw do

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  get 'sign_in', :to => 'sessions#new', :as => :sign_in
  delete 'sign_out', :to => 'sessions#destroy', :as => :sign_out

  resources :projects, :except => [:edit, :update] do
    get :pull, :on => :member
    resources :jobs, :except => [:new,:index] do
      get 'new/:task', :action => :new, :on => :collection, :as => :new
    end
  end

  require 'resque/server'
  mount Resque::Server.new, :at => "/resque"

  root :to => "dashboard#index"

end
