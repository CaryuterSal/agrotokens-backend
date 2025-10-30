class SorobanService
  SOROBAN_RPC = "https://rpc-futurenet.stellar.org"
  NETWORK = "futurenet"
  CONTRACT_ID = ENV["CONTRACT_ID"]

  # Crear la transacción sin firmar
  def self.build_unsigned_certificate_tx(cert, gov_wallet_address)
    client = Soroban::Client.new(rpc_server: SOROBAN_RPC, network: NETWORK)

    operation = Soroban::Operation.invoke_contract(
      contract_id: ENV['CONTRACT_ID'],
      function: "certificate",
      params: [
        gov_wallet_address,
        cert.uploader_wallet,
        cert.location_text,
        (cert.geo["lat"].to_f * 1_000_000).to_i,
        (cert.geo["lon"].to_f * 1_000_000).to_i,
        cert.certificate_cid,
        cert.hectares.to_i,
        "CO2-100",
        10
      ]
    )

    tx = client.build_transaction(
      source_account: gov_wallet_address,
      operations: [operation],
      fee: 100,
      timeout: 300
    )

    # Esto es lo que guardas en la tabla certificates
    tx.to_xdr(:base64)
  end

  # Enviar una transacción firmada
  def self.submit_transaction(signed_tx)
    response = HTTParty.post("#{SOROBAN_RPC}/sendTransaction", {
      headers: { "Content-Type" => "application/json" },
      body: { transaction: signed_tx }.to_json
    })
    raise "Error en envío: #{response.body}" unless response.code == 200
    JSON.parse(response.body)
  end
end
