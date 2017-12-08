class User < ApplicationRecord
  has_secure_password

  validates_uniqueness_of :email, :phone_number, :key, :account_key
  validates_presence_of :email, :phone_number, :password

  validates :email, length: { maximum: 200 }
  validates :phone_number, length: { maximum: 20 }
  validates :full_name, length: { maximum: 200 }
  validates :password, length: { maximum: 100 }
  validates :key, length: { maximum: 100 }
  validates :account_key, length: { maximum: 100 }
  validates :metadata, length: { maximum: 2000 }
end
