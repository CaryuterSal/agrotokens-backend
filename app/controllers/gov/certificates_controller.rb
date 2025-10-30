class Gov::CertificatesController < ApplicationController
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
end
