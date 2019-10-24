require "test_helper"
require 'active_support/core_ext/hash'
require 'active_support/testing/time_helpers'

module ActiveJob
  class Base
    def self.execute(serialized)
      sleep(1)
    end
  end
end

class MidgetJobTest < Minitest::Test
  include ActiveSupport::Testing::TimeHelpers

  def setup
    @attributes = {
      job_id: '98765JHGF765',
      queue: 'hokus',
      serialized: 'something',
      run_at: Time.now
    }
  end

  def test_good_create
    mj = MidgetJob.create @attributes
    refute mj.errors.any?
    assert_equal @attributes[:job_id], mj.job_id
  end

  def test_create_with_missing_job_id
    invalid_with_missing(MidgetJob, :job_id)
  end

  def test_create_with_missing_queue
    invalid_with_missing(MidgetJob, :queue)
  end

  def test_create_with_missing_serialized
    invalid_with_missing(MidgetJob, :serialized)
  end

  def test_create_with_missing_run_at
    invalid_with_missing(MidgetJob, :run_at)
  end

  def test_fire_thread
    mj = MidgetJob.create @attributes
    threads_size = Thread.list.size
    mj.fire_thread
    assert_equal threads_size + 1, Thread.list.size
  end

  def test_process_notification
    called = false
    pr = Proc.new { called = true }

    MidgetJobs::Job.stub :process_notification, pr do
      MidgetJob.process_notification({a: 'b'})
      assert called, "proc not called"
    end
  end

  def test_scope_for_processing
    travel_to Time.new(2004, 11, 24, 01, 04, 44, '+00:00') do
      assert_equal "SELECT \"midget_jobs\".* FROM \"midget_jobs\" WHERE (run_at < '2004-11-24 01:04:44')", MidgetJob.for_processing.to_sql
    end
  end

  private

  # @param [Symbol] attribute
  # @param [ApplicationRecord] klass - class of ApplicationRecord
  def invalid_with_missing(klass, attribute)
    model = klass.new @attributes.except(attribute)
    refute model.valid?
    assert model.errors.include?(attribute)
  end
end
