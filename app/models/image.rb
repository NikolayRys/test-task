class Image < ApplicationRecord
  scope :not_ready, -> { where(mime_type: nil) }
end
