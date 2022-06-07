Delayed::Worker.sleep_delay = 5
Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
