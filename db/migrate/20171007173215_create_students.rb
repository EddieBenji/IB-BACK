class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :gender, limit: 1
      t.string :shift, limit: 12
      t.string :email, limit: 255

      t.timestamps
    end
    add_index :students, :shift
    add_index :students, :email
  end
end
