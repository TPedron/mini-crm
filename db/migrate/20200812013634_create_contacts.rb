class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: true
      t.string :first_name, null: false, index: true
      t.string :last_name, null: false, index: true
      t.string :email, null: false, index: true

      t.timestamps
    end
  end
end
