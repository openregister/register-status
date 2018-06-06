Rails.application.routes.draw do
  health_check_routes

  root 'pages#home'

  get 'using-registers', to: 'pages#using_registers', as: 'using_registers'
  get 'services-using-registers', to: 'pages#services_using_registers', as: 'services_using_registers'
  get 'avaliable-registers', to: redirect('/registers', status: 301)
  get 'combining-registers', to: 'pages#combining_registers', as: 'combining_registers'
  get 'case-study-tiscreport', to: 'pages#case_study', as: 'case_study'
  get 'privacy-notice', to: 'pages#privacy_notice', as: 'privacy_notice'

  resources :registers, only: %i[show index] do
    resources :entries, path: 'updates', only: :index
    resources :download
    resources :feedback
    get '/download/success', to: 'download#success', as: 'download_success'
    get '/download-json', to: 'download#download_json', as: 'download_json'
    get '/download-csv', to: 'download#download_csv', as: 'download_csv'
  end

  resources :api_users, path: 'create-api-key'
  get '/api_users/new', to: redirect('/create-api-key', status: 301)

  get '/registers-in-progress', to: 'registers#in_progress'

  resources :suggest_registers, path: 'suggest-register', except: %i[show edit]
  get 'suggest-register/complete', to: 'suggest_registers#complete'

  resources :request_registers, path: 'request-register', except: %i[show edit]
  get 'request-register/complete', to: 'request_registers#complete'

  # Support

  get 'support', to: 'support#index'
  post 'select_support', to: 'support#select_support'

  get 'support/problem', to: 'support#problem'
  post 'support/problem', to: 'support#create'

  get 'support/question', to: 'support#question'
  post 'support/question', to: 'support#create'

  get 'support/thanks', to: 'support#thanks'

  # Request or suggest register

  get 'new-register', to: 'new_register#index'
  post 'select_request_or_suggest', to: 'new_register#select_request_or_suggest'

  get 'new-register/suggest-register', to: 'new_register#suggest_register'
  post 'new-register/suggest-register', to: 'new_register#create'

  get 'new-register/request-register', to: 'new_register#request_register'
  post 'new-register/request-register', to: 'new_register#create'

  get 'new-register/thanks', to: 'new_register#thanks'

  resource :sitemap, only: :show

  namespace :admin, path: '/admin' do
    root to: "registers#index"

    resources :registers, except: [:show] do
      collection do
        patch :sort
      end
    end
    resources :users
    resources :sessions
    get "signin" => "sessions#new"
    get "signout" => "sessions#destroy"
    resources :password_resets
  end

  get '404', to: 'errors#not_found'
  get '500', to: 'errors#internal_server_error'
end
