class Usuario < ApplicationRecord
  has_secure_password
  validates :correo, presence: true, uniqueness: true
end
