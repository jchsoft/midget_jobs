# frozen_string_literal: true
ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pg'
require 'active_record'
require 'yaml'

require 'simplecov'
SimpleCov.start 'rails'

require 'midget_jobs'

require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/stub_any_instance'

class Rails
  class << self
    attr_reader :env, :logger, :configuration
  end
  @env = 'test'
  @logger = Logger.new STDOUT
  @configuration = OpenStruct.new( x: OpenStruct.new(midget_jobs: OpenStruct.new(at_once: 2, runner: 'SomeApp')))
end

Minitest::Reporters.use!

ActiveRecord::Base.configurations = YAML.load(File.read('db/database.yml'))
puts 'drop_database'
ActiveRecord::Tasks::DatabaseTasks.drop_current
puts 'create_database'
ActiveRecord::Tasks::DatabaseTasks.create_current
puts 'migrate_database'
ActiveRecord::Tasks::DatabaseTasks.migrate
