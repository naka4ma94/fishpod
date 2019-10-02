class ChangeNameColumnOnUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :name, :string, null: false
  end

  def down
    change_column :users, :name, :string, null: true
  end
end
