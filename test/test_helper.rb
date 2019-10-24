# frozen_string_literal: true
ENV["RAILS_ENV"] = "test"
class Rails
  class << self
    attr_reader :env
  end
  @env = 'test'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pg'
require 'active_record'
require 'yaml'

require 'midget_jobs'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

ActiveRecord::Base.configurations = YAML.load(File.read('db/database.yml'))
puts 'drop_database'
ActiveRecord::Tasks::DatabaseTasks.drop_current
puts 'create_database'
ActiveRecord::Tasks::DatabaseTasks.create_current
puts 'migrate_database'
ActiveRecord::Tasks::DatabaseTasks.migrate
