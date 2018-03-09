class Student < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  validates_uniqueness_of(:email)

  def email_registered?
    Student.find_by_email(email) ? true : false
  end

  def verify_email_does_exists(email)
    old_student = Student.find_by_email(email)
    old_student.id != id
  end

  # @param [Object] new_student
  # @return [Object]
  def student_updated_correctly?(new_student)
    if verify_email_does_exists(new_student[:email])
      return { email: 'invalid', updated: false }
    end
    if update!(new_student)
      { email: 'valid', updated: true }
    else
      { email: 'valid', updated: false }
    end
  end

end
