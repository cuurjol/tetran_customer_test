class Customer < ApplicationRecord
  VALID_PHONE_REGEX = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/.freeze

  validates :name, presence: true
  validates :description, presence: true
  validates :phone, presence: true, length: { maximum: 15 }, format: { with: VALID_PHONE_REGEX }
end
