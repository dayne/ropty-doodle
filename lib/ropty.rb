# lib/ropty.rb
require_relative 'ropty/server'
require_relative 'ropty/websocket_controller'

module Ropty
  def self.start
    Server.run!
  end
end
