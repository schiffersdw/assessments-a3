class InvoicesController < ApplicationController
    before_action :authorize_request
    before_action :find_invoice, except: %i[create index]

    # GET /invoices
     def index
        @invoices = Invoice.eager_load(:emmiter, :receiver, :user).all
        render json: @invoices, status: :ok
    end

    # GET /invoices/{_uuid}
    def show
        render json: @invoice, status: :ok
    end

    # POST /invoices
    def create
        @invoice = Invoice.new(invoice_params)
        if @invoice.save
            render json: @invoice, status: :created
        else
            render json: { errors: @invoice.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    # PUT /invoices/{_uuid}
    def update
        unless @invoice.update(invoice_params)
            render json: { errors: @invoice.errors.full_messages },
                    status: :unprocessable_entity
        end
    end

    private
    def find_invoice
        @invoice = Invoice.find_by_uuid!(params[:_uuid])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'Invoice not found' }, status: :not_found
    end
    
    def invoice_params
        params.permit(:amount, :currency, :emitted_at, :expires_at, :signed_at, :cfdi_digital_stamp)
    end

end
