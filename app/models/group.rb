class Group < ApplicationRecord
    has_and_belongs_to_many :contacts
    belongs_to :user

  end
  