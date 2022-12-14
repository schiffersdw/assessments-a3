# frozen_string_literal: true

class InvoicesController < ApplicationController
  before_action :authorize_request
  before_action :find_invoice, except: %i[create index massive_upload]

  # GET /invoices
  def index
    # Main queryset
    @invoices = Invoice.eager_load(:emitter, :receiver, :user)

    # Apply filters
    @invoices = @invoices.with_status(params[:status])
                         .with_emmiter_id(params[:emitter_id])
                         .with_receiver_id(params[:receiver_id])
                         .with_emitted_at_range(params[:date_from], params[:date_to])
                         .with_amount_lte(params[:amount_from])
                         .with_amount_gte(params[:amount_to])

    # Get total of selection
    total = @invoices.total()

    # Set pagination
    @invoices = @invoices.page(params[:page])

    # Return render
    render json: {
      total_pages: @invoices.total_pages, total_entries: @invoices.total_entries, 
      current_page: @invoices.current_page, total:, data: @invoices } , status: :ok
  end

  # GET /invoices/{_id}
  def show
    render json: @invoice, status: :ok
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)

    @invoice.set_uuid
    @invoice.set_stamp
    @invoice.user = @current_user

    if @invoice.save
      render json: @invoice, status: :created
    else
      render json: { errors: @invoice.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /invoices/{_uuid}
  def update
    @invoice.set_stamp
    if @invoice.update(invoice_params)
      render json: @invoice, status: :ok
    else
      render json: { errors: @invoice.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /invoices/{_uuid}
  def destroy
    if @invoice.update({ active: false })
      render json: @invoice, status: :ok
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /invoices/massive_upload
  def massive_upload
    if params[:file].present?

      message, errors, completes = Invoice.import_from_zip(params[:file], @current_user)

      render json: {
        message:,
        errors:,
        completes:
      }, status: :ok
    else
      render json: { message: 'Attach zip file with invoices' }, status: :unprocessable_entity
    end
  end

  # GET /invoices/{_uuid}/stamp_qr
  def stamp_qr
    # Create QR Code
    qrcode = RQRCode::QRCode.new(@invoice.cfdi_digital_stamp)
    png = qrcode.as_png(
      bit_depth: 2,
      border_modules: 1,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      size: 600
    )
    png_path = "storage/stamps/#{@invoice.id}.png"
    File.binwrite(png_path, png.to_s)
    send_file png_path, type: 'image/png', disposition: 'inline'
  end

  private

  def find_invoice
    @invoice = Invoice.find(params[:_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Invoice not found' }, status: :not_found
  end

  def invoice_params
    params.permit(:amount, :currency, :emitted_at, :expires_at, :signed_at, :receiver_id, :emitter_id)
  end
end
