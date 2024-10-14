class AddFieldsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :provider unless column_exists?(:users, :provider)
      t.string :uid unless column_exists?(:users, :uid)
    end
  end
end
