require_relative "../lib/resque"

# Return the number of pending jobs by queues
def get_queues_stats

	queues = Resque.redis.smembers("queues").sort!

	stats = Resque.redis.pipelined do
		queues.each do |queue|
			Resque.redis.llen("queue:" + queue)
		end
	end

	items = []
	i = 0
	queues.each do |queue|
		items.push({:label => queue, :value => stats[i]})
		i += 1
	end

	return items
end

SCHEDULER.every('5s', first_in: '1s') {
	send_event('resque_queues_stats', { items: get_queues_stats })
}