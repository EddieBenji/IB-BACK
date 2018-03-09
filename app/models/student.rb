class Student < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  validates_uniqueness_of(:email)

  def is_email_registered
    Student.find_by_email(email) ? true : false
  end

  def verify_does_exists_email(email)
    old_student = Student.find_by_email(email)
    old_student.id != id
  end

end
