class AddUserIdToContacts < ActiveRecord::Migration[7.2]
  def change
    add_reference :contacts, :user, foreign_key: true
  end
end
