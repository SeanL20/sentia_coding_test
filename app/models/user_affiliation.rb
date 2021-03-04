class UserAffiliation < ApplicationRecord
  belongs_to :user
  belongs_to :affiliation
end
