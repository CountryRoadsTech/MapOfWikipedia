require 'wikipedia'

class ProcessNodesLinksWorker
  #include Sidekiq::Worker
  #sidekiq_options queue: 'critical', retry: 10

  def perform(node_id)
    node = Node.find(node_id)

    if node.nil?
      puts "#{Time.zone.now}"
      puts "ERROR: Found a nil node from ProcessNodesLinksWorker!"
    else

    end
  end
end
