require 'midget_jobs/job'

module ActiveJob
  module QueueAdapters
    class MidgetJobAdapter
      attr_accessor(:perform_enqueued_jobs, :perform_enqueued_at_jobs, :filter, :reject, :queue)

      def enqueue(job) #:nodoc:
        Rails.logger.debug "job: #{job}"
        JobWrapper.enqueue job
      end

      def enqueue_at(job, timestamp) #:nodoc:
        Rails.logger.debug "job: #{job}, #{timestamp}"
        JobWrapper.enqueue job, at: timestamp
      end

      def enqueued_jobs
        JobWrapper.enqueued_jobs
      end

      def performed_jobs
        []
      end

      class JobWrapper < MidgetJobs::Job
        def run(serialized_job)
          Base.execute serialized_job
        end
      end
    end
  end
end
