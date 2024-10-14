class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :notes, dependent: :destroy

  has_many :shared_notes_received, class_name: 'SharedNote', foreign_key: 'shared_to_id'
  has_many :shared_notes_given, class_name: 'SharedNote', foreign_key: 'shared_by_id'

  def self.from_google(u)
    create_with(uid: u[:uid], provider: 'google',
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end


end
