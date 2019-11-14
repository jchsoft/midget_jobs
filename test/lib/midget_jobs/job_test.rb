require "test_helper"
require 'active_support/testing/assertions'

class JobTest < Minitest::Test
  include ActiveSupport::Testing::Assertions

  def test_enqueue_job
    MidgetJob.delete_all
    assert_difference('MidgetJob.count') do
      MidgetJobs::Job.enqueue OpenStruct.new({job_id: 'FGHDG45645', queue_name: 'queue_name', serialize: 'serialize'})
    end
  end

  def test_enqueue_delayed_job
    MidgetJob.delete_all
    assert_difference('MidgetJob.count') do
      MidgetJobs::Job.enqueue OpenStruct.new({job_id: 'FGHDG45645', queue_name: 'queue_name', serialize: 'serialize'}), at: 1.hour.from_now
    end
  end

  def test_enqueue_delayed_job_as_float
    MidgetJob.delete_all
    assert_difference('MidgetJob.count') do
      MidgetJobs::Job.enqueue OpenStruct.new({job_id: 'FGHDG45645', queue_name: 'queue_name', serialize: 'serialize'}), at: 1.hour.from_now.to_f
    end
  end


  def test_enqueue_delayed_job_as_int
    MidgetJob.delete_all
    assert_difference('MidgetJob.count') do
      MidgetJobs::Job.enqueue OpenStruct.new({job_id: 'FGHDG45645', queue_name: 'queue_name', serialize: 'serialize'}), at: 1.hour.from_now.to_i
    end
  end

  def test_enqueued_job
    MidgetJob.delete_all
    assert_equal 0, MidgetJobs::Job.enqueued_jobs.count
    MidgetJobs::Job.enqueue OpenStruct.new({job_id: 'FGHDG45645', queue_name: 'queue_name', serialize: 'serialize'})
    MidgetJobs::Job.enqueue OpenStruct.new({job_id: 'HDG4453645', queue_name: 'queue_name', serialize: 'serialize'})
    assert_equal 2, MidgetJobs::Job.enqueued_jobs.count
  end

  def test_schedule_start
    MidgetJobs::Scheduler.stub_any_instance(:call, 'running') do
      refute_equal 'running', MidgetJobs::Job.scheduler
      MidgetJobs::Job.schedule
      assert_equal 'running', MidgetJobs::Job.scheduler
    end
  end

  def test_process_notification
    wakeup_signalized = false
    pr = Proc.new { wakeup_signalized = true }

    MidgetJobs::Scheduler.stub_any_instance(:wakeup!, pr) do
      MidgetJobs::Job.schedule
      refute wakeup_signalized
      assert_nothing_raised do
        MidgetJobs::Job.process_notification({action: 'INSERT'})
      end
      assert wakeup_signalized
    end
  end

  def test_wrong_process_notification
    wakeup_signalized = false
    pr = Proc.new { wakeup_signalized = true }

    MidgetJobs::Scheduler.stub_any_instance(:wakeup!, pr) do
      MidgetJobs::Job.schedule
      refute wakeup_signalized
      assert_raises ArgumentError do
        MidgetJobs::Job.process_notification({action: 'UPDATE'})
      end
      refute wakeup_signalized
    end
  end
end
