require 'newrelic_rpm' unless Rails.env.development? || Rails.env.test?
