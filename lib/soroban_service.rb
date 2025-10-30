class SorobanService
  SOROBAN_RPC = "https://rpc-futurenet.stellar.org"
  NETWORK = "futurenet"
  CONTRACT_ID = ENV["SBN_CONTRACT_ID"]
  NETWORK_PASSPHRASE = "Test SDF Future Network ; October 2022"

  # ✅ Genera transacción sin firmar (usando la CLI soroban)
  def self.build_unsigned_certificate_tx(cert, gov_wallet)
    lat_micro = (cert.geo["lat"].to_f * 1_000_000).to_i
    lon_micro = (cert.geo["lon"].to_f * 1_000_000).to_i

    cmd = <<~CMD
      #{ENV["SBN_PATH"]} contract invoke \
        --rpc-url #{SOROBAN_RPC} \
        --network #{NETWORK} \
        --network-passphrase "#{NETWORK_PASSPHRASE}" \
        --id #{CONTRACT_ID} \
        -s #{gov_wallet} \
        --build-only \
        -- \
        certificate \
        --gov #{gov_wallet} \
        --owner #{cert.uploader_wallet} \
        --name "#{cert.location_text}" \
        --lat-micro #{lat_micro} \
        --lon-micro #{lon_micro} \
        --certificate "#{cert.certificate_cid}" \
        --hectares #{cert.hectares.to_i} \
        --carbon-offset "CO2-100" \
        --tokens-per-hectare 10
    CMD

    xdr, stderr, status = Open3.capture3(cmd)

    if status.success?
      puts "✅ Transacción creada: #{xdr}"
    else
      raise "Error creando transacción: #{stderr}" unless $?.success?
    end

    xdr.strip
  end

  # ✅ Enviar transacción firmada (desde el frontend)
  def self.submit_transaction(signed_tx)
    response = HTTParty.post("#{SOROBAN_RPC}/sendTransaction", {
      headers: { "Content-Type" => "application/json" },
      body: { transaction: signed_tx }.to_json
    })

    raise "Error en envío: #{response.body}" unless response.code == 200
    JSON.parse(response.body)
  end
end
