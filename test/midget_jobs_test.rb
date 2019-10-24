require "test_helper"

class MidgetJobsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MidgetJobs::VERSION
  end

  def test_initialize_workers
    schedule_called = false
    schedule_pr = Proc.new { schedule_called = true }
    listen_notifications_called = false
    listen_notifications_pr = Proc.new { listen_notifications_called = true }

    MidgetJobs::Job.stub :schedule, schedule_pr do
      MidgetJob.stub :listen_notifications, listen_notifications_pr do
        MidgetJobs.initialize_workers
        assert schedule_called, "proc not called"
        assert listen_notifications_called, "proc not called"
      end
    end
  end
end
