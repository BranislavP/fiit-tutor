class RemoveSubjectFromEventsAndAddSubjectToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :subject, :string
    add_reference :events, :subject, index: true, null: false
  end
end
