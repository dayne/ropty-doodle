# `ropty`

`ropty` the read-only  Pty website tool. 

Not relevant to anyone but [dayne](https://github.com/dayne) ... for now.

## Why?

... personal reasons. 

## Security Considerations

Security Considerations
- **Sanitize Output:** Ensure the output streamed to the client does not contain any sensitive information or control sequences that could exploit the client's browser.
- **Read-Only:** The setup described is inherently read-only because it does not process any input from the client to the pty session. Still, ensure that this is strictly enforced.
- **Process Isolation:** Run the terminal process with minimal privileges to reduce security risks. Consider using containers or virtual machines for additional isolation.

## Setup

```
# have ruby + bundler available
git clone
bundle
```

## `tree`

```
ropty/
├── bin/
│   └── start_server # Script to start the web server
│   └── roapty.rb    # Badly built test websocket client. 
├── config/
│   └── server_config.rb  # Configuration for the web server
├── lib/
│   ├── ropty/
│   │   ├── server.rb # Core server implementation
│   │   └── websocket_controller.rb  # WebSocket controller to manage connections
│   └── ropty.rb     # Entry point for the ropty library
├── public/
│   ├── index.html   # Frontend HTML for the ropty terminal display
│   └── js/
│       └── app.js   # JavaScript for managing WebSocket connections and UI updates
├── Gemfile          # Defines project dependencies for Ruby
├── Gemfile.lock     # Snapshots the exact versions of gems that should be installed
├── README.md        # Project overview, setup instructions, and usage
└── Rakefile         # Defines tasks for common administrative tasks
```
