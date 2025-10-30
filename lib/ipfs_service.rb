# frozen_string_literal: true

class IpfsService
  BASE_URL = "https://api.pinata.cloud/pinning/pinFileToIPFS"
  DOWNLOAD_URL = "https://ivory-gigantic-whitefish-149.mypinata.cloud/ipfs/"

  def self.upload(file)
    response = HTTParty.post(
      BASE_URL,
      headers: {
        "Authorization" => "Bearer #{ENV['PINATA_JWT']}"
      },
      body: {
        file: UploadIO.new(file, "application/pdf", file.original_filename)
      },
      multipart: true
    )

    if response.code == 200
      JSON.parse(response.body)["IpfsHash"]
    else
      raise "Pinata upload failed: #{response.body}"
    end
  end

  def self.download(cid)
    response = HTTParty.get("#{DOWNLOAD_URL}#{cid}")

    raise "Error descargando archivo desde IPFS" unless response.success?

    # Crear un archivo temporal con el contenido
    temp_file = Tempfile.new(["ipfs_", ".pdf"], binmode: true)
    temp_file.write(response.body)
    temp_file.rewind

    temp_file
  end
end