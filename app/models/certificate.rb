class Certificate < ApplicationRecord
  validates :certificate_cid, presence: true
  enum :status, [:pending, :parsed, :review, :awaiting_signature, :rejected, :minted]
end
