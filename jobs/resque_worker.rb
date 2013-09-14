require_relative "../lib/resque"

SCHEDULER.every('1m', first_in: '1s') {
	send_event('resque_workers_count', { current: Resque.workers.count })
}