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
    require "nokogiri"
    def self.import_from_zip(file, current_user)
        errors = []
        completes = 0

        result, files = ZipHelper::read(file)
        if(!result)
            return "Attach zip file with invoices", errors, completes
        else
            #Fetchs XML Results
            for r in files
                #Read xml
                xml = Nokogiri::XML(File.open(r))

                #Create invoice object
                invoice = Invoice.new
                #Set valuess
                invoice.uuid = xml.xpath("//invoice_uuid").inner_html
                invoice.active = xml.xpath("//status").inner_html == "active"
                invoice.currency = xml.xpath("//invoice_uuid").inner_html
                invoice.emitted_at = xml.xpath("//emitted_at").inner_html
                invoice.expires_at = xml.xpath("//expires_at").inner_html
                invoice.signed_at = xml.xpath("//signed_at").inner_html
                invoice.cfdi_digital_stamp = xml.xpath("//cfdi_digital_stamp").inner_html
                invoice.user = current_user
                #Get amounts
                invoice.currency = xml.xpath("//amount/currency").inner_html
                cents = xml.xpath("//amount/cents").inner_html

                #Convert to amount
                amount = Money.new(cents.to_i, invoice.currency)
                invoice.amount = amount
                
                #Set dependencies
                invoice.emitter = Emitter.find_or_create_by(
                    :rfc => xml.xpath("//emitter/rfc").inner_html,
                    :name => xml.xpath("//emitter/name").inner_html
                )

                invoice.receiver = Receiver.find_or_create_by(
                    :rfc => xml.xpath("//receiver/rfc").inner_html,
                    :name => xml.xpath("//receiver/name").inner_html
                )
                
                #Save invoices
                begin
                    invoice.save
                rescue Exception => e
                    errors.push(e.message)
                else
                    completes += 1
                end
                
            end

            #Retunr response
            return "File processeded", errors, completes
        end

    end


end
