class CreateNotePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :note_permissions do |t|
      t.integer :note_id, null: false
      t.integer :user_id, null: false
      t.string :permission
      t.string :shared_by
      t.string :shared_to

      t.timestamps
    end

    add_index :note_permissions, :note_id
    add_index :note_permissions, :user_id
  end
end
