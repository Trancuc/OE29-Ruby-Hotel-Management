class Type < ApplicationRecord
  has_many :rooms, dependent: :destroy
end
