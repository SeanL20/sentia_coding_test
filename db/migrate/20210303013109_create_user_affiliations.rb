class CreateUserAffiliations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_affiliations do |t|
      t.references :user, foreign_key: true
      t.references :affiliation, foreign_key: true

      t.timestamps
    end
  end
end
