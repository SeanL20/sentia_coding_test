class User < ApplicationRecord
  has_many :user_affiliations, dependent: :destroy
  has_many :affiliations, through: :user_affiliations
  has_many :user_locations, dependent: :destroy
  has_many :locations, through: :user_locations

  validates :first_name, presence:true
  validates :gender, presence: true
  validates :species, presence: true

	def self.import_csv(csv_data)
		CSV.foreach(csv_data, headers: true, :row_sep => :auto) do |data|
      user = data.to_hash
      if user["Affiliations"].blank?
        next
      else

      	user_name = User.split_name(user["Name"])

        csv_user = User.create(
          first_name: user_name[:first_name],
          last_name: user_name[:last_name],
          species: user["Species"],
          gender: user["Gender"],
          weapon: user["Weapon"],
          vehicle: user["Vehicle"]
        )

        User.save_location(user["Location"], csv_user)
        User.save_affiliation(user["Affiliations"], csv_user)
      end
	  end
	end

	def self.split_name(name)
    split_name = name.split(" ")
    if split_name.size > 2
      first_name = split_name[0].capitalize
      for i in 1..(split_name.size-2)
        first_name = first_name + " #{split_name[i].capitalize}"
      end
      last_name = split_name.last.capitalize
    elsif split_name.size == 1
      first_name = split_name[0].capitalize
      last_name = ""
    else
      first_name = split_name[0].capitalize
      last_name = split_name.last.capitalize
    end
		
    user_name = {
			first_name: first_name,
			last_name: last_name
    }

    return user_name
	end

	def self.save_location(csv_location, user)
    if Location.exists?(title: csv_location)
      location = Location.find_by(title: csv_location.titlecase)
    else
      location = Location.create(title: csv_location.titlecase)
    end
		
    user.locations << location
	end

	def self.save_affiliation(csv_affiliation, user)
    if Affiliation.exists?(title: csv_affiliation)
      affiliation = Affiliation.find_by(title: csv_affiliation)
    else
      affiliation = Affiliation.create(title: csv_affiliation)
    end

    user.affiliations << affiliation
	end

  def full_name
    self.first_name + ' ' + self.last_name
  end
end
