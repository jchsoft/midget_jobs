require "midget_job/version"
require 'active_job/queue_adapters/midget_job_adapter'
require 'midget/job'
require 'midget/scheduler'
require 'models/midget_job'

module MidgetJobs
  class Error < StandardError; end
  def self.initialize_workers
    Midget::Job.schedule
    MidgetJob.listen_notifications
  end
end
