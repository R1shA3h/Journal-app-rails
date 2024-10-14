class Note < ApplicationRecord
  belongs_to :user
  has_many_attached :files do |attachables|
    attachables.variant :thumb, resize_to_fill: [200,200]
  end
  validates :title, presence: true
  validates :description, presence: true
  validates :visibility, presence: true, inclusion: { in: %w(public private shared) }

  # Validation for file size (restricting to 10 MB)
  validate :files_size_validation

  # Validation for acceptable file types (image, video, documents)
  validate :acceptable_file_types

  private

  def files_size_validation
    files.each do |file|
      if file.byte_size > 10.megabytes
        errors.add(:files, "should be less than 10 MB each")
      end
    end
  end

  def acceptable_file_types
    files.each do |file|
      acceptable_types = ["image/jpeg", "image/png", "image/gif", "video/mp4", "application/pdf", "text/plain"]
      unless acceptable_types.include?(file.content_type)
        errors.add(:files, "must be a JPEG, PNG, GIF image, MP4 video, PDF, or plain text file")
      end
    end
  end
end
