class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :registration_number
      t.string :name
      t.string :branch

      t.timestamps null: false
    end
  end
end
