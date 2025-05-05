class Usuario < ApplicationRecord
  has_secure_password
  has_many :temas, dependent: :destroy
  
  validates :correo, 
    presence: true,
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
    
  validates :password,
    length: { minimum: 6 },
    if: -> { new_record? || !password.nil? }
end
