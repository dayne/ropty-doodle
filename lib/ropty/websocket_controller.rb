# lib/ropty/websocket_controller.rb
require 'rainbow'
require 'faye/websocket'
require 'pty'
require 'thread'
require 'open3'
require 'pry'
require 'thin'
Faye::WebSocket.load_adapter('thin')

module Ropty
  class WebSocketController
    attr_reader :ws
    @ws_clients = []
    @pty_thread = nil
    @running = false
    @mutex = Mutex.new

    class << self
      attr_accessor :pty_thread, :ws_clients, :running, :mutex

      def init_class_variables
        puts Rainbow("Initializing class variables").orange
        @ws_clients = []
        @pty_thread = nil
        @running = false
        @mutex = Mutex.new
      end
    end

    self.init_class_variables

    KEEPALIVE_TIME = 15 # in seconds
    def initialize(env)
      @ws = setup(env)
    end

    def rack_response
      rr = @ws.rack_response
      puts Rainbow(rr.inspect).yellow
      rr
    end

    def setup(env)
      puts Rainbow("Ropty::WebSocketController Initializing ...").green
      env['HTTP_UPGRADE'] ||= 'websocket'
      #env['HTTP_CONNECTION'] ||= 'Upgrade'
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})
      self.class.ws_clients << ws

      self.class.start_pty unless self.class.running

      puts Rainbow("WS: setup_websocket(): Setting up WebSocket event handlers...").green
      ws.on :error do |event|  
        puts Rainbow("WS: Websocket Error: #{event.message}").red
        ws.send("Error: #{event.message}")
      end

      ws.on :open do |event|
        puts Rainbow("WS: Websocket opened.").green
        ws.send("Hello! Welcome to Ropty!")
      end

      ws.on :message do |event|
        puts Rainbow("WS: Received message: #{event.data}").green
        # Since this is a read-only view, we do not handle incoming messages.
      end

      ws.on :close do |event|
        puts Rainbow("WS: Websocket closed.").red
        self.class.ws_clients.delete(ws)
        @running = false
      end

      puts Rainbow("WS: WebSocketController initialized.").green
      ws
    rescue StandardError => e
      puts Rainbow("WS: Error setting up WebSocket").red
      puts Rainbow(e.message).red
      puts e.backtrace
      raise
    end

    def self.start_pty
      mutex.synchronize do
        if @running
          puts Rainbow("start_pty(): PTY already running").yellow
          return
        end
        @running = true
      end

      begin 
        master, slave = PTY.open
        spawn('mosquitto_sub', '-h', 'localhost', '-t', 'hi', in: slave, out: slave)
        #slave.close
        #spawn('bash', in: slave, out: slave)
        @pty_thread = Thread.new do
          begin
            while @running
              output = master.readpartial(512)
              puts Rainbow("@pty_thread @ws_clients.size=#{@ws_clients.size} read: #{output}").purple
              if @ws_clients.empty?
                  puts Rainbow("No clients connected").yellow
                  self.stop_pty
                  break
              else
                @mutex.synchronize do
                  @ws_clients.each { |client| client.send(output) }
                end
              end
            end
          rescue EOFError => e
            puts Rainbow("PTY read thread ending - EOF reached").red
          rescue IOError => e
            puts Rainbow("PTY read thread ending - IO Error").red
          ensure
            master.close
          end
        end
        puts Rainbow("start_pty(): PTY started @running=true").purple
      rescue StandardError => e
        puts Rainbow("WS: Error starting PTY").red
        puts Rainbow(e.message).red
        @mutex.synchronize { @running = false }
      end
    end

    def self.stop_pty
      @running = false
      #self.stop_pty
      @mutex.synchronize do
        @pty_thread&.kill
        @pty_thread = nil
        @ws_clients.each { |client| client.close }
        @ws_clients.clear
        puts Rainbow("stop_pty(): PTY stopped").purple
      end
    end
  end
end
