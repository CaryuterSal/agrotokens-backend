class Certificate < ApplicationRecord
  validates :certificate_cid, presence: true
  enum :status, [:pending, :parsed, :review, :approved, :rejected, :minted]
end
