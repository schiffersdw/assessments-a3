class Invoice < ApplicationRecord
    belongs_to :receiver
    belongs_to :emitter
    belongs_to :user


end
