class ReceiversController < ApplicationController
    before_action :authorize_request

    # GET /receivers
    def index
        @receivers = Receiver.all
        render json: @receivers, status: :ok
    end

    # GET /receivers/{_id}
    def show
        render json: @receiver, status: :ok
    end
    
    # POST /receivers
    def create
        @receiver = Receiver.new(receiver_params)
        if @receiver.save
            render json: @receiver, status: :created
        else
            render json: { errors: @receiver.errors.full_messages },
                status: :unprocessable_entity
        end
    end
    
    # PUT /receivers/{_id}
    def update
        if @receiver.update(receiver_params)
            render json: @receiver, status: :ok
        else
            render json: { errors: @receiver.errors.full_messages },
                    status: :unprocessable_entity
        end
    end
    
    private
    
    def find_receiver
        @receiver = Receiver.find_by_id!(params[:_id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'receiver not found' }, status: :not_found
    end
    
    def receiver_params
        params.permit(:name, :rfc)
    end

end
