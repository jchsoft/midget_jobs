require 'test_helper'
require 'generators/midget_install/midget_install_generator'

class MidgetInstallGeneratorTest < Rails::Generators::TestCase
  tests MidgetInstallGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
