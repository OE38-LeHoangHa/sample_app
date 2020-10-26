class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, length: {maximum: Settings.max_name}
  validates :email, presence: true, length: {maximum: Settings.max_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.min_password}
  has_secure_password
  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
