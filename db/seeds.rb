# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

STARTING_PAGE_NAME = 'Jesus'
GRAPH_NAME = 'Map of (English) Wikipedia'

puts "#{Time.zone.now}"
puts "rake db:seed... Starting"

map_of_wikipedia = Graph.find_or_create_by_name(GRAPH_NAME)

wikipedia_dump = Nokogiri::XML::Reader(File.open('/home/addisonmartin/Downloads/data'))

wikipedia_dump.each do |page|

  puts page.name
  puts page.attributes.each do |attribute|
    puts attribute
  end
  puts page.value
  puts page.inner_xml

  node = Node.create!({
                        name: page.name,
                        graph: map_of_wikipedia
                      })

  puts "#{Time.zone.now}"
  puts "Saved new node for page #{node.name}"
end

puts "#{Time.zone.now}"
puts "rake db:seed... Complete"
puts "========================================="
puts "#{map_of_wikipedia.nodes.count} total pages saved"
puts "#{map_of_wikipedia.edges.count} total edges saved"
puts "#{map_of_wikipedia.categories.count} total categories saved"
puts "========================================="
