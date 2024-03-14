#!/usr/bin/env ruby
require 'faye/websocket'
require 'eventmachine'


$URL='ws://localhost:31337/ws/'
puts $URL
EM.run {
  ws = Faye::WebSocket::Client.new($URL)

  ws.on :open do |event|
    p [:open]
    ws.send('Hello, world!')
  end

  ws.on :message do |event|
    #p [:message, event.data]
    puts event.data
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
    exit
  end
}
