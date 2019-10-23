require "midget_jobs/version"
require 'active_job/queue_adapters/midget_job_adapter'
require 'midget_jobs/job'
require 'midget_jobs/scheduler'
require 'models/midget_job'

module MidgetJobs
  class Error < StandardError; end
  def self.initialize_workers
    MidgetJobs::Job.schedule
    MidgetJob.listen_notifications
  end
end
