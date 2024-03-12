# config.ru
require 'rack'
require 'thin'
require 'faye/websocket'
Faye::WebSocket.load_adapter('thin')
require_relative 'lib/ropty'

# Use Rack::Static to serve static files from the public directory
use Rack::Static, urls: ["/css", "/js", "/images", "/matrix-effect"], root: "public"
use Rack::Logger

map '/ws/' do
  puts Rainbow("config.ru: Mapping /ws to Ropty::Server").yellow
  run Ropty::Server
end

map '/' do
  puts Rainbow("config.ru: Mapping / to Ropty::Server").yellow
  run lambda { |env|  
    status, headers, body = [200, {'content-type' => 'text/html'}, File.open('public/index.html', File::RDONLY)]  
    puts Rainbow("config.ru: Status: #{status}").yellow
    [status, headers, body]
  }
end
