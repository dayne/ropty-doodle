# lib/ropty/server.rb

# `Ropty::Server` is responsible for handling incoming requests 
# and deciding whether to handle them as WebSocket requests or 
# delegate them to another application. 

# `Ropty::WebSocketController`, on the other hand, is 
# responsible for handling WebSocket connections.

require_relative 'config'
require_relative 'websocket_controller'
require 'rainbow'
require 'pry'

module Ropty
  class Server
    def initialize
      puts Rainbow("Server.initialize(): Initializing Ropty::Server").orange
    end

    def self.call(env)
      puts Rainbow("Server.call(): Handling request").green
      if Faye::WebSocket.websocket?(env)
        # WebSocket request handling
        ws = WebSocketController.new(env)
        ws.rack_response
      else
        # Non-WebSocket request handling
        @app.call(env)
      end
    end
  end
end
