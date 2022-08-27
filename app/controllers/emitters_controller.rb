class EmittersController < ApplicationController
    before_action :authorize_request
    before_action :find_emitter, except: %i[create index]

    # GET /emitters
    def index
        @emitters = Emitter.all
        render json: @emitters, status: :ok
    end

    # GET /emitters/{_id}
    def show
        render json: @emitter, status: :ok
    end
    
    # POST /emitters
    def create
        @emitter = Emitter.new(emitter_params)
        if @emitter.save
            render json: @emitter, status: :created
        else
            render json: { errors: @emitter.errors.full_messages },
                status: :unprocessable_entity
        end
    end
    
    # PUT /emitters/{_id}
    def update
        if @emitter.update(emitter_params)
            render json: @emitter, status: :ok
        else
            render json: { errors: @emitter.errors.full_messages },
                    status: :unprocessable_entity
        end
    end
    
    # DELETE /emmiters/{_id}
    def destroy
        if @emitter.update({active: false})
            render json: @emitter, status: :ok
        else
            render json: { errors: @emitter.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    private
    def find_emitter
        @emitter = Emitter.find_by_id!(params[:_id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'emitter not found' }, status: :not_found
    end
    
    def emitter_params
        params.permit(:name, :rfc)
    end

end
