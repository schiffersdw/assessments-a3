require 'securerandom'

class Invoice < ApplicationRecord
    belongs_to :receiver
    belongs_to :emitter
    belongs_to :user

    def set_uuid()
        self.uuid = SecureRandom.uuid
    end

    def set_stamp()
        self.cfdi_digital_stamp = FFaker::DizzleIpsum.characters
    end

end
