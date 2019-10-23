$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'active_record'
require "midget_jobs"

require "minitest/autorun"
require 'minitest/reporters'

Minitest::Reporters.use!

