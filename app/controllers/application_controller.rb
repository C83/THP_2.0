class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :rescue_bad_params
  rescue_from ActionController::ParameterMissing, with: :rescue_param_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def rescue_bad_params(exception)
    render json: { error: exception.record.errors.full_messages }, status: :forbidden
  end

  def rescue_param_missing
    render json: { errors: [exception.message] }, status: :forbidden
  end

  def record_not_found(exception)
    render json: { errors: [exception.message] }, status: :not_found
  end
end
