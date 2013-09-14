require_relative "../lib/resque"
require "resque_scheduler"

# Get scheduled jobs stats
# Return an array of jobs number per timestamp
def get_scheduled_jobs
	t = Time.now
	startTime = Time.new(t.year, t.month, t.day, t.hour)
	endTime = startTime + 60 * 60 * 5 # Get stats for the next 5 hours
	timestamps = Resque.redis.zrangebyscore(:delayed_queue_schedule, startTime.to_i, endTime.to_i)

	stats = Resque.redis.pipelined do
		timestamps.each do |timestamp|
			Resque.redis.llen("delayed:" + timestamp.to_s)
		end
	end

	Hash[timestamps.zip stats]
end

SCHEDULER.every('1s', first_in: '1s') {
	send_event('resque_scheduler_queue', { items: get_scheduled_jobs })
}