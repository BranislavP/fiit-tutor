class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :subject, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
