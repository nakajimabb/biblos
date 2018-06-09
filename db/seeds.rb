# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(code: 'admin', email: 'admin@biblos.jp' , password_confirmation: 'koinonia', password: 'koinonia', lang: :ja)
User.create!(code: :ja, email: 'ja@biblos.jp' , password_confirmation: 'koinonia', password: 'koinonia', lang: :ja)
User.create!(code: :en, email: 'en@biblos.jp' , password_confirmation: 'koinonia', password: 'koinonia', lang: :en)
