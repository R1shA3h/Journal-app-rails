class NotePermission < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :permission, inclusion: { in: %w[read write] }
  validates :shared_by, presence: true
  validates :shared_to, presence: true

  def note_editable?
    self.permission == "write"
  end
end
