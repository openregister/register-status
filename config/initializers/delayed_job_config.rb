Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 30.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term

Delayed::Worker.logger ||= if defined?(Rails)
                             Rails.logger
                           elsif defined?(RAILS_DEFAULT_LOGGER)
                             RAILS_DEFAULT_LOGGER
                           else
                             Logger.new(File.join(@worker_options[:log_dir], 'delayed_job.log'))
                           end
