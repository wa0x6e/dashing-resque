require_relative "../lib/resque"

# Return count of processed and failed jobs
def get_stats
	stats = Resque.redis.pipelined do
		Resque.redis.get("stat:processed")
		Resque.redis.get("stat:failed")
	end

	stats
end

SCHEDULER.every('2s', first_in: '1s') {
	stats = get_stats
	send_event('resque_processed_jobs', { current: stats[0] })
	send_event('resque_failed_jobs', { current: stats[1] })
}