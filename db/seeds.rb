# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Event.delete_all
User.delete_all
Tag.delete_all
tags = Faker::Lorem.words(10)
10.times{|i|
	email="example_"+i.to_s+"@example.com"
	password = "Password"
	u = User.create!(email: email, password:password)
	5.times{ |j|
		e_tag = tags.sample+','+tags.sample
		location = Faker::Address.street_name.to_s+' '+
							Faker::Address.building_number.to_s
			event_params = {title: Faker::Lorem.words(4).join(' '),
					  start_date:Faker::Date.backward(30),
					 	end_date:Faker::Date.backward(14),
					 	location: Faker::Company.name,
					 	agenda: Faker::Lorem.words(10).join(' '),
					 	address: location.to_s,
					 	all_tags: e_tag,
					 	organizer_id: u}
			e = u.organized_events.create!(event_params)	
	}
}
