# frozen_string_literal: true

module PostgresNotificationsListener
  def listen_notifications
    Rails.logger.info "#{self.name} listening_job started"
    Thread.new do
      Rails.logger.info "#{self.name} listening_job running on #{self.name.pluralize.underscore}_notices"
      self.connection.execute "LISTEN #{self.name.pluralize.underscore}_notices"
      loop do
        begin
          Rails.logger.info "#{self.name} listening_job wait_for_notify"
          self.connection.raw_connection.wait_for_notify do |event, pid, payload|
            data = JSON.parse payload, symbolize_names: true
            Rails.logger.info "postgres #{event.inspect}, pid: #{pid.inspect}, data: #{data.inspect}"
            process_notification(data)
          end
        rescue StandardError => error
          Rails.logger.error "-------------Ex #{self.name} listening_job wait_for_notify #{error}----------------"
          retry
        end
      end
    end.abort_on_exception = true
  end
end
