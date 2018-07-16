class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[show update destroy]

  def index
    lessons = Lesson.all
    render json: lessons, status: :ok
  end

  def create
    this_lesson = Lesson.create!(lesson_params)
    render json: this_lesson, status: :created
  end

  def show
    render json: @this_lesson, status: :ok
  end

  def update
    @this_lesson.update!(lesson_params)
    render json: @this_lesson, status: :ok
  end

  def destroy
    @this_lesson.destroy
    render status: :no_content
  end

  private

  def set_lesson
    @this_lesson = Lesson.find_by!(params.permit(:id))
  end

  def lesson_params
    params.require(:lesson).permit(:title, :description)
  end
end
