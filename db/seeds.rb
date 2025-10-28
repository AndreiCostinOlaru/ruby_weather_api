# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default favorites for default_user
["Chicago", "New York", "Los Angeles"].each do |city|
  Favorite.find_or_create_by!(user_id: "default_user", city: city)
end

puts "Created #{Favorite.count} favorites"
