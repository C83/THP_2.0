class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, ActionController::ParameterMissing, with: :show_errors_403
  rescue_from ActiveRecord::RecordNotFound, with: :show_errors_404

  def show_errors_403(exception)
    render json: exception, status: :forbidden
  end

  def show_errors_404(exception)
    render json: exception, status: :not_found
  end
end
