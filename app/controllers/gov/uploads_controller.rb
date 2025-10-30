class Gov::UploadsController < ApplicationController
  def create
    file = params[:file]
    wallet = params[:uploader_wallet]
    raise "Archivo no encontrado" unless file
    raise "Wallet no proporcionada" unless wallet

    # Subir a IPFS
    cid = IpfsService.upload(file)

    # Crear registro
    cert = Certificate.create!(
      certificate_cid: cid,
      uploader_wallet: wallet,
      status: "pending"
    )

    # Procesar OCR
    ProcessCertificateJob.perform_later(cert.id)

    render json: { success: true, cid: cid, id: cert.id }
  rescue => e
    render json: { success: false, error: e.message }, status: 400
  end
end
