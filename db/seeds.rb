# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "#{Time.zone.now}"
puts "Starting..."

map_of_wikipedia = Graph.build_from_starting_node_name('Jesus', 'Map of (English) Wikipedia')

puts "#{Time.zone.now}"
puts "Map of Wikipedia...complete?"
puts "#{map_of_wikipedia.nodes.count} total pages saved"
puts "#{map_of_wikipedia.edges.count} total edges saved"
puts "#{map_of_wikipedia.categories.count} total categories saved"
