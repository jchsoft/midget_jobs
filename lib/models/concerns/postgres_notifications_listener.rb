# frozen_string_literal: true

module PostgresNotificationsListener
  def listen_notifications
    Rails.logger.info "#{name} listening_job started"
    Thread.new do
      Rails.logger.info "#{name} listening_job running on #{name.pluralize.underscore}_notices"
      connection.execute "LISTEN #{name.pluralize.underscore}_notices"
      loop do
        Rails.logger.info "#{name} listening_job wait_for_notify"
        connection.raw_connection.wait_for_notify do |event, pid, payload|
          data = JSON.parse payload, symbolize_names: true
          Rails.logger.info "postgres #{event.inspect}, pid: #{pid.inspect}, data: #{data.inspect}"
          process_notification(data)
        end
      rescue ActiveRecord::StatementInvalid => e
        Rails.logger.error "Ex #{name} listening_job wait_for_notify #{e}-retrying!"
        if e.to_s.include?('PG::ConnectionBad')
          Rails.logger.error "Reestablish AR connection..."
          ActiveRecord::Base.connection.verify!
        end
        sleep 0.1
        retry
      rescue StandardError => e
        Rails.logger.error "Ex #{name} listening_job wait_for_notify #{e}-retrying!"
        retry
      end
    end.abort_on_exception = true
  end
end
