class AddVisibilityToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :visibility, :string,default: 'private'
  end
end
