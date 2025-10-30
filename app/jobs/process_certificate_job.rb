class ProcessCertificateJob < ApplicationJob
  queue_as :default

  def perform(cert_id)
    cert = Certificate.find(cert_id)
    file = IpfsService.download(cert.certificate_cid)
    parsed = OcrService.parse(file)

    cert.update!(
      parsed_json: parsed,
      hectares: parsed["hectares"],
      location_text: parsed["location_text"],
      confidence: parsed["confidence"],
      geo: { lat: parsed["lat"], lon: parsed["lon"] },
      status: "parsed"
    )

    # Crear la transacción sin firmar
    if parsed["confidence"].to_f >= 0.85
      unsigned_tx = SorobanService.build_unsigned_certificate_tx(cert, cert.uploader_wallet)
      cert.update!(
        status: "awaiting_signature",
        unsigned_tx: unsigned_tx # guardamos el base64
      )
    else
      cert.update!(status: "review")
    end
  rescue => e
    Rails.logger.error("processing error: #{e.message}")
    cert.update!(status: "error") if cert
  end
end
