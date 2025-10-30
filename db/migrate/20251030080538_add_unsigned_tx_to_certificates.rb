class AddUnsignedTxToCertificates < ActiveRecord::Migration[8.0]
  def change
    add_column :certificates, :unsigned_tx, :text
    add_column :certificates, :blockchain_batch_id, :string
  end
end
