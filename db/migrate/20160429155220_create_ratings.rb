class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.text :content, null: false
      t.float :score, null: false
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
    add_column :ratings, :tutor_id, :integer, foreign_key: true, null: false
  end
end
