# frozen_string_literal: true

class IpfsService
  BASE_URL = "https://api.pinata.cloud/pinning/pinFileToIPFS"
  DOWNLOAD_URL = "https://ipfs.io/ipfs/"

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
    HTTParty.get("#{DOWNLOAD_URL}#{cid}").body
  end
end