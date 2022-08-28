class Emitter < ApplicationRecord

    scope :search_query, lambda {|param| 
        if param
            where("UPPER(name) LiKE ? ",  "%#{param.upcase()}%")
        end
    }

    scope :actives, lambda {where(:active => true)}

end
