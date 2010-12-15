VivoReportSaver::Application.routes.draw do
  resources :queries do
    member do 
      get 'run'
    end
  end

  root :to => "home#index"
end
