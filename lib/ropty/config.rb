# config/server_config.rb

module Ropty
  class Config
    def self.server
      {
        port: ENV.fetch("ROPTY_PORT", 9292),
        environment: ENV.fetch("ROPTY_ENV", "development"),
      }
    end

    # WebSocket configuration
    def self.websocket
      {
        max_connections: 100,
        timeout: 30, # In seconds
      }
    end

    # Logging configuration
    def self.logging
      {
        level: ENV.fetch("LOG_LEVEL", "debug"),
        file: "log/#{ENV.fetch("ROPTY_ENV", "development")}.log",
      }
    end

  end
end
