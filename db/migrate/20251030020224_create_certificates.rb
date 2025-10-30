class CreateCertificates < ActiveRecord::Migration[8.0]
  def change
    create_table :certificates do |t|
      t.string :certificate_cid
      t.string :uploader_wallet
      t.jsonb :parsed_json
      t.float :hectares
      t.string :location_text
      t.jsonb :geo
      t.string :status
      t.float :confidence
      t.string :metadata_cid

      t.timestamps
    end
  end
end
