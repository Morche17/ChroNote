class Nota < ApplicationRecord
  belongs_to :tema
  
  validates :nombre, :descripcion, presence: true
end
