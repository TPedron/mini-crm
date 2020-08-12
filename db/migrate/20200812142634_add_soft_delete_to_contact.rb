class AddSoftDeleteToContact < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :deleted, :boolean, default: false, index: true
  end
end
