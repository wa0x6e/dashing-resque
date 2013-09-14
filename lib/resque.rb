require "yaml"
require "resque"

dashing_env = ENV['DASHING_ENV'] || 'development'

resque_config = YAML.load_file(File.dirname(__FILE__) + '/../config/resque.yml')
Resque.redis =  resque_config[dashing_env]