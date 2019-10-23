require 'models/midget_job'
require 'midget/scheduler'

module Midget
  class Job
    class_attribute :scheduler

    class << self
      # @param [ActiveJob::Base] job
      # @param [Time] at
      def enqueue(job, at: nil)
        MidgetJob.create!(job_id: job.job_id, queue: job.queue_name, serialized: job.serialize, run_at: (at or 1.second.from_now))
      end

      def enqueued_jobs
        MidgetJob.all
      end

      def schedule
        @scheduler = Midget::Scheduler.new.call
      end

      def process_notification(hash_data)
        Rails.logger.info "#{self.name}.#{__method__}(#{hash_data})"
        case hash_data[:action]
          when 'INSERT'
            @scheduler.wakeup!
          else
            raise "unknown action #{hash_data[:action]}"
        end
      end
    end

    def run(serialized_job)
      raise NotImplementedError, "serialized_job: #{serialized_job}"
    end
  end
end
