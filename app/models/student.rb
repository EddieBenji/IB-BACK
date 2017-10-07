class Student < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates_uniqueness_of(:email)

  def is_email_registered
    Student.find_by_email(email) ? true : false
  end

end
