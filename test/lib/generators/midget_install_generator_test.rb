require 'test_helper'
require 'generators/midget_jobs/install_generator'

class MidgetInstallGeneratorTest < Rails::Generators::TestCase
  tests MidgetJobs::InstallGenerator
  destination '' # n Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
