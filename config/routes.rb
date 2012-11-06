RedneckCurrent::Application.routes.draw do
    root :to => "user#index"
    match '/users' => 'user#create', :via => :post
    resources :user do
      match '/user' => 'user#create', :via => :post, :as => :user
    end
    match ':controller(/:action(/:id(.:format)))'
end
