# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true
  validates :username, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  scope :search_query, lambda { |param|
    where('UPPER(name) LiKE ? ', "%#{param.upcase}%") if param
  }

  scope :actives, -> { where(active: true) }
end
