class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.text :acronym
      t.text :name
      t.integer :level

      t.timestamps null: false
    end
  end
end
