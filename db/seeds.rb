# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
admin = User.find_or_create_by!(email_address: "jenaro@hey.com") do |user|
  user.password = "Jenaro123!"
  user.password_confirmation = "Jenaro123!"
  user.admin = true
  puts "Created admin user"
end

# Create regular users
[ "john@example.com", "jane@example.com", "test@example.com" ].each do |email|
  User.find_or_create_by!(email_address: email) do |user|
    user.password = "password123"
    user.password_confirmation = "password123"
    puts "Created user: #{email}"
  end
end
