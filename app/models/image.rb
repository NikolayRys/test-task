class Image < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  scope :not_ready, -> { where(mime_type: nil) }
end
