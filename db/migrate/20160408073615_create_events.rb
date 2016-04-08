class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :subject, null: false
      t.text :description
      t.string :place, null: false
      t.timestamp :date, null: false
      t.float :cost, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :events, [:user_id, :created_at]
  end
end
