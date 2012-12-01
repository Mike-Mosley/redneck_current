RedneckCurrent::Application.routes.draw do
    root :to => "user#index"
    match ':controller(/:action(/:id(.:format)))'
end
