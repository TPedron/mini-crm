class CreateJoinTableContactsTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :contacts, :tags do |t|
      t.index %i[contact_id tag_id]
      t.index %i[tag_id contact_id]
    end
  end
end
