require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User",
                 :username => "example",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar",
                 :address => "57 Glen Drive")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      username = "example-#{n+1}"
      email = "example@railstutorial.org"
      address = "57 Glen Drive"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :username => username,
                   :address => address,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
