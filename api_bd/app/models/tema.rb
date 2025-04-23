class Tema < ApplicationRecord
  belongs_to :usuario
  has_many :notas, dependent: :destroy
  
  validates :nombre, presence: true
end
