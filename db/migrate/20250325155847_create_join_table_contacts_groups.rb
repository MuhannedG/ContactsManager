class CreateJoinTableContactsGroups < ActiveRecord::Migration[7.2]
  def change
    create_join_table :contacts, :groups do |t|
      # t.index [:contact_id, :group_id]
      # t.index [:group_id, :contact_id]
    end
  end
end
