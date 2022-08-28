require 'securerandom'

class Invoice < ApplicationRecord
    belongs_to :receiver
    belongs_to :emitter
    belongs_to :user
    
    #Available filters
    scope :with_status, lambda {|param| 
        where("invoices.status = ?", param) if param
    }
    scope :with_emmiter_id, lambda {|param|
        where("invoices.emitter_id = ?", param) if param
    }
    scope :with_receiver_id, lambda {|param| 
        where("invoices.receiver_id = ?", param) if param
    }
    scope :with_emitted_at_range, lambda {|p_from, p_to| 
        where("invoices.emmited_at BETWEEN ? AND ?", p_from, p_to) if p_from and p_to
    }
    scope :with_amount_gte, lambda {|param| 
        where("invoices.amount >= ?", param) if param
    }
    scope :with_amount_lte, lambda {|param| 
        where("invoices.amount < = ?", param) if param
    }

    #Collection methods
    def self.total()
        self.sum(:amount)
    end

    #Object methods
    def set_uuid()
        self.uuid = SecureRandom.uuid
    end

    def set_stamp()
        self.cfdi_digital_stamp = FFaker::DizzleIpsum.characters
    end


    #Massive load of invoices
    def self.import_from_zip(file)
        errors = 0
        completes = 0

        result, files = ZipHelper::read(file)
        if(!result)
            return "Attach zip file with invoices", errors, completes
        else
            #Fetchs XML Results
            for r in files
                #Read xml
                print(r)
            end

            #Retunr response
            return "File processeded", errors, completes
        end

    end


end
