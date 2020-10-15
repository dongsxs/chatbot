#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
class Lita::CommanderMiddleware
  # Lita calls this method to build a new sonos commander instance.
  #   open_sockets is an empty array provided by the caller to allow
  #   communication via shared memory between the middleware and Lita.
  def self.build(open_sockets:)
    new(open_sockets: open_sockets).build
  end

  # exposes .env and .open_sockets getters for use by other objects.
  attr_reader :env, :open_sockets

  # open_sockets is required - we can't operate as intended without it.
  def initialize(open_sockets:)
    @open_sockets = open_sockets
  end

  # Handle an expected incoming client websocket connection
  #   or send back some usage instructions in case of invalid input.
  def build
    lambda do |env|
      if Faye::WebSocket.websocket?(env)
        @env = env
        handle_env_has_socket
      else
	# "Sorry, I can't work with this input."
        http_explainer_payload
      end
    end
  end

  # Store an incoming client socket connection in :open_sockets
  #   so we can send it messages later.
  def build_socket(env)
    ws = Faye::WebSocket.new(env)
    open_sockets << ws
    Lita.logger.debug "Sonos client count: #{open_sockets.count}"
    ws
  end

  # "Hi you're in the right place!"
  def send_welcome_message(ws)
    payload = { message: 'Welcome to Lita Sonos Commander!', command: 'echo' }
    ws.send(payload.to_json)
  end

  # "Message received." Lets the client know they are ready to go and
  #   should stand by for further instructions.
  def handle_message(ws, event)
    ws.send({ message: "ACK: #{event.data}" }.to_json)
  end

  # Discard any handles to client connections as they disconnect
  #   from your socket server.
  def close_socket(ws, event)
    open_sockets.delete_if { |s| s == ws }
    Lita.logger.debug "Sonos client count: #{open_sockets.count}"
    Lita.logger.debug "Socket close: #{[:close, event.code, event.reason]}"
    ws = nil
  end

  # Client's incoming connection is a websocket as expected.
  #   Set it up, add it to the list of sockets, and send the client
  #   an acknowledgement.
  def handle_env_has_socket
    ws = build_socket(env)

    send_welcome_message(ws)

    # Register handler method for incoming messages from client
    ws.on(:message) { |event| handle_message(ws, event) }
    # Register handler method for "goodbye" messages from client
    ws.on(:close) { |event| close_socket(ws, event) }

    # Return async Rack response now
    ws.rack_response
  end

  # "Hi, you've made a simple web request to a socket. I can't help you
  #   unless you send us a websocket request instead."
  def http_explainer_payload
    [
      200,
      { 'Content-Type' => 'text/plain' },
      ['Hello from a Lita chatbot! Feed me a websocket connection!']
    ]
  end
end
