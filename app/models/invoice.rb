class Invoice < ApplicationRecord
    belongs_to :receiver
    belongs_to :emmiter
    belongs_to :user


end
