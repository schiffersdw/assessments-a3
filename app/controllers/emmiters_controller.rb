class EmmitersController < ApplicationController
    before_action :authorize_request
    before_action :find_emmiter, except: %i[create index]

    # GET /emmiters
    def index
        @emmiters = Emmiter.all
        render json: @emmiters, status: :ok
    end

    # GET /emmiters/{_id}
    def show
        render json: @emmiter, status: :ok
    end
    
    # POST /emmiters
    def create
        @emmiter = Emmiter.new(emmiter_params)
        if @emmiter.save
            render json: @emmiter, status: :created
        else
            render json: { errors: @emmiter.errors.full_messages },
                status: :unprocessable_entity
        end
    end
    
    # PUT /emmiters/{_id}
    def update
        unless @emmiter.update(emmiter_params)
            render json: { errors: @emmiter.errors.full_messages },
                    status: :unprocessable_entity
        end
    end
    
    private
    
    def find_emmiter
        @emmiter = Emmiter.find_by_id!(params[:_id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'emmiter not found' }, status: :not_found
    end
    
    def emmiter_params
        params.permit(:name, :rfc)
    end

end
