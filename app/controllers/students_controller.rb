class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :update, :destroy]

  # GET /students
  def index
    query = 'first_name ILIKE ? AND last_name ILIKE ? AND email ILIKE ? AND shift ILIKE ? AND gender ILIKE ?'
    @students = Student.where(query, '%' + params[:first_name] + '%',
                              '%' + params[:last_name] + '%',
                              '%' + params[:email] + '%',
                              '%' + params[:shift] + '%',
                              '%' + params[:gender] + '%')
    render json: @students
  end

  # GET /students/1
  def show
    render json: @student
  end

  # POST /students
  def create
    @student = Student.new(student_params)
    # validations:
    if @student.is_email_registered
      render json: {status: 'Error', code: 422, message: I18n.t('email_registered')}
      return
    end
    if @student.save!
      render json: @student, status: :created, location: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1
  def update
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
