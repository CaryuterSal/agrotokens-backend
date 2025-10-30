Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Gobierno
  namespace :gov do
    # 1️⃣ Subir certificado (archivo PDF, CSV, etc.)
    # POST /gov/uploads
    resources :uploads, only: [:create]

    # 2️⃣ Certificados (ver, firmar y enviar)
    # GET /gov/certificates/:id → ver estado o datos
    # POST /gov/certificates/:id/sign_and_submit → firma y envío blockchain
    resources :certificates, only: [:show] do
      member do
        post :sign_and_submit
      end
    end
  end

  # API pública / inversionistas
  namespace :api do
    resources :batches, only: [ :index, :show ]
    resources :purchases, only: [ :create, :index ]
  end
end
