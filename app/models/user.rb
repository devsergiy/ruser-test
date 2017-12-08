class User < ApplicationRecord
  has_secure_password
  has_secure_token :key

  validates_uniqueness_of :email, :phone_number, :key, :account_key, allow_nil: true

  validates_presence_of :email, :phone_number
  validates_presence_of :password, on: :create
  validates_presence_of :password_digest, on: :update

  validates :email, length: { maximum: 200 }
  validates :phone_number, length: { maximum: 20 }
  validates :full_name, length: { maximum: 200 }
  validates :password, length: { maximum: 100 }
  validates :key, length: { maximum: 100 }
  validates :account_key, length: { maximum: 100 }
  validates :metadata, length: { maximum: 2000 }

  after_create :enqueue_account_key

  private

  def enqueue_account_key
    GetAccountKeyJob.perform_later(self)
  end
end
