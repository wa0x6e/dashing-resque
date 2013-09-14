# Resque widget for Dashing

## Description

![](http://f.cl.ly/items/2b1s0c3V3i1s0Z0Z1m1D/dashing-resque-widget.png)

Resque [dashing](http://shopify.github.com/dashing) widget to monitor [resque](https://github.com/resque/resque) jobs, queues and worker activities.

This family contains 5 different widgets:

* **Workers count**: display the number of workers
* **Processed jobs count**: display the total number of processed jobs
* **Failed jobs count**: display the total number of failed jobs
* **Queues stats**: display the number of pending jobs for each queues
* **Scheduled jobs heatmap**: display a heatmap of scheduled jobs for the next 5 hours

## Dependencies

[resque](https://github.com/resque/resque)  
[resque-scheduler](https://github.com/resque/resque-scheduler)  
[redis](https://github.com/redis/redis-rb)

Add them to dashing's gemfile:

	gem 'redis'
	gem 'resque'
	gem 'resque-scheduler'

and run `bundle install`.

## Usage

To use this widget, copy all the files into their respectives folders.

Then include the desired widget in a dashboard, by adding the following snippet to your dashboard layout file:

* For the scheduled jobs heatmap widget
```html
<li data-row="1" data-col="1" data-sizex="2" data-sizey="1">
  <div data-id="resque_scheduler_queue" data-view="ResqueHeatmap"  data-title="Scheduled jobs"></div>
</li>
```

* For the queues widget
```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="2">
  <div data-id="resque_queues_stats" data-view="ResqueList" data-title="Queued jobs"></div>
</li>
```

* For the processed jobs counter widget
```html
<li data-row="1" data-col="1" data-sizex="2" data-sizey="1">
  <div data-id="resque_processed_jobs" data-view="ResqueGraph"  data-title="Processed Jobs"></div>
</li>
```

* For the failed jobs counter widget
```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="resque_failed_jobs" data-view="ResqueGraph"  data-title="Failed Jobs"></div>
</li>
```

* For the workers count widget
```html
<li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
  <div data-id="resque_workers_count" data-view="ResqueNumber"  data-title="Resque Workers"></div>
</li>
```

Each widget corresponds to a job file (in the `/jobs` folder), except the processed and failed jobs counter widgets, that belongs to the same `resque_job.rb`.  
To avoid sending unecessary requests to the redis server, only include the jobs you're using in the `/jobs` folder.

## Settings

### Redis server

You can configure the redis server address in the */config/resque.yml* file.
You can define multiple address depending on the environment:

	development: localhost:6379
	production: /tmp/redis.sock

The environment used is read from `ENV['DASHING_ENV']`.

### Scheduled jobs heatmap

Each cell in the heatmap is representing the number of scheduled jobs per minute.  

Since each application have their own order of magnitude, the difference between the minimum and maximum scheduled jobs per minute differs for each system.  
Set the `@maxJobPerMinute` variable, in `/widgets/resque_heatmap/resque_heatmap.coffee` to the approximative number of maximum scheduled jobs per minute of your application, to have the widest color range for the heatmap.

### Processed and failed jobs graph

You can customize the "time range" of the graph, by editing the `graphWidth` variable in `/widgets/resque_graoh/resque/graph.coffee`. By default, it'll only display the last minute.