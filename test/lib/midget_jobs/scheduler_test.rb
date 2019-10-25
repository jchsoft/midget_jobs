require "test_helper"
require 'active_support/testing/assertions'

class SchedulerTest < Minitest::Test
  def test_call_scheduler
    scheduler = MidgetJobs::Scheduler.new.call
    thread = scheduler.instance_variable_get(:@thread)
    assert_instance_of Thread, thread
    thread.join 0.1
    assert thread.stop? # dead or sleeping.
    assert thread.alive? # running or sleeping.
    assert_equal 'sleep', thread.status
  end

  def test_wakeup_adding_record
    MidgetJob.delete_all

    thread_fired = false
    pr = Proc.new { thread_fired = true }

    MidgetJob.stub_any_instance(:fire_thread, pr) do
      scheduler = MidgetJobs::Scheduler.new.call
      thread = scheduler.instance_variable_get(:@thread)
      thread.join 0.1
      MidgetJob.create!(job_id: 'ZTR8765', queue: 'QQQQ', serialized: 'serialized', run_at: 1.second.from_now)
      scheduler.wakeup!
      thread.join 1
      assert thread_fired
      assert_empty MidgetJob.all.to_a
      thread.kill
    end
  end
end
