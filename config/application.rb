require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module AuthAccessControl
  class Application < Rails::Application
    config.load_defaults 7.0
    
    # Configuration for the application
    config.time_zone = 'UTC'
    
    # Autoload paths
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/app/policies)
    config.autoload_paths += %W(#{config.root}/app/decorators)
    
    # Active Job adapter
    config.active_job.queue_adapter = :sidekiq
  end
end
