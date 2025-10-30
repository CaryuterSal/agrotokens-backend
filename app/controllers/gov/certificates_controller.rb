class Gov::CertificatesController < ApplicationController
  before_action :find_certificate, only: %i[show sign_and_submit]

  # GET /gov/certificates/:id
  def show
    render json: @certificate
  end

  def sign_and_submit
    cert = Certificate.find(params[:id])
    signed_tx = params[:signed_tx]
    raise "No transaction provided" unless signed_tx

    # Enviar a Soroban
    result = SorobanService.submit_transaction(signed_tx)

    cert.update!(status: "minted", blockchain_batch_id: result["id"])
    render json: { success: true, tx_hash: result["id"] }
  rescue => e
    render json: { success: false, error: e.message }, status: 400
  end


  def find_certificate
    @certificate = Certificate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Certificate not found" }, status: 404
  end
end
