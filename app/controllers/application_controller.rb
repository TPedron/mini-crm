class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: ErrorMessageBuilderService.map_error(e), status: :unprocessable_entity
  end
end
