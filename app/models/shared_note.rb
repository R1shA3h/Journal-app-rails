class SharedNote < ApplicationRecord
  belongs_to :note
  belongs_to :user

  validates :permissions, presence: true# Allow only read or write permissions
end
