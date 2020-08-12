class ApplicationController < ActionController::API
  def hash_params
    @hash_params ||= params.to_unsafe_h.deep_transform_keys(&:underscore).deep_symbolize_keys
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: ErrorMessageBuilderService.map_error(e), status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: ErrorMessageBuilderService.map_error(e), status: :not_found
  end
end
