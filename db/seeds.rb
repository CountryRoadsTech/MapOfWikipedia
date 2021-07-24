include ActionView::Helpers

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

STARTING_PAGE_NAME = 'Jesus'
TOTAL_NUMBER_OF_ENGLISH_WIKIPEDIA_PAGES = 6338381
GRAPH_NAME = 'Map of (English) Wikipedia'

puts "#{Time.zone.now}"
puts "rake db:seed... Starting"

map_of_wikipedia = Graph.find_or_create_by_name(GRAPH_NAME)
Node.find_or_create_by_name(STARTING_PAGE_NAME, map_of_wikipedia)

puts "#{Time.zone.now}"
puts "rake db:seed... Complete"
puts "========================================="
puts "#{map_of_wikipedia.nodes.count} total pages saved"
puts "#{number_to_percentage(map_of_wikipedia.nodes.finished_processing.count.to_f/TOTAL_NUMBER_OF_ENGLISH_WIKIPEDIA_PAGES.to_f, precision: 4)} complete processing all pages on English Wikipedia"
puts "#{map_of_wikipedia.nodes.finished_processing.count} total pages processed"
puts "#{TOTAL_NUMBER_OF_ENGLISH_WIKIPEDIA_PAGES} total pages on English Wikipedia"
puts "#{map_of_wikipedia.nodes.errored_processing.count} total pages had errors processing"
puts "#{map_of_wikipedia.nodes.needs_processing.count} total pages unprocessed"
puts "#{map_of_wikipedia.nodes.marked_for_processing.count} total pages marked for processing"
puts "#{map_of_wikipedia.edges.count} total edges saved"
puts "#{map_of_wikipedia.categories.count} total categories saved"
puts "========================================="
