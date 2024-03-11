# lib/ropty.rb
require 'rack'
require 'thin'
require 'faye/websocket'
Faye::WebSocket.load_adapter('thin')
require_relative 'ropty/server'
require_relative 'ropty/websocket_controller'

module Ropty
  def self.start
    Server.run!
  end
end
