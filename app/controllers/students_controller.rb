class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :update, :destroy]

  # GET /students
  def index
    query = 'first_name ILIKE ? AND last_name ILIKE ? AND email ILIKE ? AND shift ILIKE ? AND gender ILIKE ?'
    @students = Student.where(query, '%' + params[:first_name] + '%',
                              '%' + params[:last_name] + '%',
                              '%' + params[:email] + '%',
                              '%' + params[:shift] + '%',
                              '%' + params[:gender] + '%').order(:first_name, :last_name)
    render json: @students
  end

  # GET /students/1
  def show
    render json: @student
  end

  # POST /students
  def create
    @student = Student.new(student_params)
    if @student.is_email_registered
      render json: {
          statusText: I18n.t('custom_errors.email_registered'), status: 422, message: I18n.t('custom_errors.email_registered')
      }, status: :unprocessable_entity
      return
    end
    # validations:
    if @student.save!
      render json: @student, status: :created, location: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.verify_does_exists_email(params[:student][:email])
      render json: {
          statusText: I18n.t('custom_errors.email_registered'), status: 422, message: I18n.t('custom_errors.email_registered')
      }, status: :unprocessable_entity
      return
    end
    if @student.update!(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def student_params
    params.require(:student).permit(:first_name, :last_name, :age, :gender, :shift, :email)
  end
end
