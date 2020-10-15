#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'pry'

# loads all external dependencies to enable proper websocket
#   handling and operations 
require 'json'
require 'faye/websocket'
require 'uri'

module Lita
  module Handlers
    class SonosCommander < Handler

      # build a class-wide persistent list of open websockets to reuse on
      #  incoming messages
      @_sockets ||= []

      # delegate to the above-defined socket list whenever the class is
      #   asked for its socket list
      def self.sockets
        @_sockets
      end

      # don't track your own list of sockets, delegate to the class
      def sockets
        self.class.sockets
      end

      # confirm web requests are routed to the expected method
      http.get '/sonos/listen', :websocket_creator


      # confirm basic chat commands are sent to the desired
      #   handler methods
      route(/^play url (http.+)/i, :handle_sonos_play_url)
      route(/^speak words (.+)/i, :handle_sonos_say_text)

      # start up websocket handler once Lita is loaded
      on :loaded, :register_faye

      # build a new handler for each incoming websocket request
      def websocket_creator(request, _response)
        # could probably skip straight to the Commander middleware
        # but it's cleaner to leave them all in play.

        middleware_registry.each do |mw|
          mw.middleware.call(request.env)
        end
      end

      # when asked to play a URL, send a coded message to all registered
      #   socket clients saying "hey, play this URL"
      def handle_sonos_play_url(message)
        return message.reply('No clients found!') unless sockets.any?

        text = message.matches.last.last
        play_url message.matches.last.last

        message.reply "Command sent: [play_url] #{text}!"
      end

      # send a :play_url command to remote clients
      def play_url(url)
        emit_message command: 'play_url', data: URI.escape(url)
      end

      # when asked to speak some words aloud, send a coded message to
      #   all registered socket clients saying "hey, say these words"
      def handle_sonos_say_text(message)
        return message.reply('No clients found!') unless sockets.any?

        text = message.matches.last.last
        say_text text

        message.reply "Command sent: [play_text] #{text}!"
      end

      # send a :play_text command to all connected clients
      def say_text(text)
        emit_message command: 'play_text', data: text
      end

      # Build a new websocket handler middleware to receive any
      #   future incoming client websocket connection attempts.
      #   Add the Commander to Lita's web middleware list so that
      #   it can be applied to future incoming messages.
      def register_faye(_arg)
        socket_manager = Lita::CommanderMiddleware.build(open_sockets: sockets)
        middleware_registry.use socket_manager
      end

      # Provide a handle to Lita's HTTP middleware so that you
      #   can submit a Commander object to its list of handlers later.
      def middleware_registry
        robot.registry.config.http.middleware
      end

      # Send a specific coded message with arguments to all connected
      #   websocket clients
      def emit_message(command:, data:)
        Lita.logger.debug "emitting #{command} \t #{data}"

        sockets.each do |ws|
          ws.send serialize(command: command, text: data)
        end
      end

      # Convert a command such as :play_text to a JSON format that
      #   can be sent across the websocket to remote clients.
      #   The clients should be able to understand and act upon it.
      def serialize(command:, text:)
        {
          command: command,
          data: { text: text, volume: 40 }
        }.to_json
      end

      Lita.register_handler(self)
    end
  end
end
