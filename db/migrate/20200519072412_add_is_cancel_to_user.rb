class AddIsCancelToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_cancel, :boolean
  end
end
