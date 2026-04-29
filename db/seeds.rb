# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "login: #{Rails.application.credentials.dig(:admin, :nickname)}"
admin_login = Rails.application.credentials.dig(:admin, :nickname)
admin_password = Rails.application.credentials.dig(:admin, :password)
if admin_login.present? && admin_password.present?
	unless User.exists?(nickname: admin_login)
		User.create!(
			nickname: admin_login,
			password: admin_password,
			password_confirmation: admin_password,
			user_name: "admin",
			status: "in_service",
			staff_grade: "administrator",
			)
		puts "Admin account created"
	else
		puts "Admin account already exists"
	end
end