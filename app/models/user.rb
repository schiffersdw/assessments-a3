class User < ApplicationRecord

    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

    scope :search_query, lambda {|param| 
        if param
            where("UPPER(name) LiKE ? ",  "%#{param.upcase()}%")
        end
    }

    scope :actives, lambda {where(:active => true)}

end