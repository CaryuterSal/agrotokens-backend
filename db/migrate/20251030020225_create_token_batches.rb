class CreateTokenBatches < ActiveRecord::Migration[8.0]
  def change
    create_table :token_batches do |t|
      t.bigint :batch_id
      t.references :certificate, null: false, foreign_key: true
      t.string :issuer_wallet
      t.integer :total_tokens
      t.integer :tokens_per_hectare
      t.string :metadata_cid
      t.string :minted_tx_hash

      t.timestamps
    end
  end
end
