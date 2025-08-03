class Product < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :by_code, ->(code) { where(code: code).first }
end
