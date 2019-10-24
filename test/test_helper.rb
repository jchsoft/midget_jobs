# frozen_string_literal: true
ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pg'
require 'active_record'
require 'yaml'

require 'midget_jobs'

require 'minitest/autorun'
require 'minitest/reporters'

class Rails
  class << self
    attr_reader :env, :logger
  end
  @env = 'test'
  @logger = Logger.new STDOUT
end

Minitest::Reporters.use!

ActiveRecord::Base.configurations = YAML.load(File.read('db/database.yml'))
puts 'drop_database'
ActiveRecord::Tasks::DatabaseTasks.drop_current
puts 'create_database'
ActiveRecord::Tasks::DatabaseTasks.create_current
puts 'migrate_database'
ActiveRecord::Tasks::DatabaseTasks.migrate
