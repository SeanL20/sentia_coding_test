class Affiliation < ApplicationRecord
  has_many :user_affiliations, dependent: :destroy
  has_many :users, through: :user_affiliations
end
