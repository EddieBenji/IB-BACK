class StudentsController < ApplicationController
  before_action :set_student, only: %i[show update destroy]

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
    if @student.email_registered?
      render_error_payload(:email_registered, status: :forbidden)
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
    response = @student.student_updated_correctly?(student_params)
    if response[:email] == 'invalid'
      render_error_payload(:email_registered, status: :forbidden)
    elsif response[:email] == 'valid' && response[:updated] == false
      render json: @student.errors, status: :unprocessable_entity
    else
      render json: @student
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
  end

  protected

  def render_error_payload(identifier, status: :bad_request)
    render json: ErrorPayload.new(identifier, status), status: status
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def student_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :age,
      :gender,
      :shift,
      :email
    )
  end
end
