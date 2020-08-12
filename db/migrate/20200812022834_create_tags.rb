class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.uuid :uuid, null: false, default: 'gen_random_uuid()', index: true
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
