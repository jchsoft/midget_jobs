require 'models/concerns/postgres_notifications_listener'

class MidgetJob < ActiveRecord::Base
  extend PostgresNotificationsListener

  scope :for_processing, -> { where('run_at < ?', Time.current) }

  validates :job_id, :queue, :serialized, :run_at, presence: true

  def fire_thread
    Rails.logger.info "#{self.class.name} fire_thread started"
    Thread.new do
      Rails.logger.info "#{self.class.name}.fire_thread execute serialized job"
      begin
        ActiveJob::Base.execute serialized
      rescue => detail
        Rails.logger.error detail.cause
      end
    end
  end

  def self.process_notification(hash_data)
    Midget::Job.process_notification hash_data
  end
end
