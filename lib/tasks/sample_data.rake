namespace :db do 
  desc "Fill database with sample data"
  task populate: :environment do 
    User.create!(name: "Nate Norberg",
                 email: "natenorberg@gmail.com",
                 password: "password1",
                 password_confirmation: "password1")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end 
  end 
end