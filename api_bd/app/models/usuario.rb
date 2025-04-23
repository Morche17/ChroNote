class Usuario < ApplicationRecord
  has_secure_password
  has_many :temas, dependent: :destroy
  # Añade validaciones si es necesario
end
