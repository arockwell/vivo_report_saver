VivoReportSaver::Application.routes.draw do
  resources :queries 

  # I should convert this to a nested resource
  match '/queries/:id/run/:db', :to => 'queries#run', :as => "run_query"

  root :to => "home#index"
end
