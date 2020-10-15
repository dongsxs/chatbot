#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'cleverbot'

module Lita
  module Handlers
    class CleverbotDemo < Handler
      # allow user to set API keys as environment variables
      #   or via lita_config.rb
      config :cleverbot_user, default: ENV.fetch('CLEVERBOT_USER')
      config :cleverbot_key, default: ENV.fetch('CLEVERBOT_KEY')

      # note this route's regex is more open-ended than usual!
      route(/^cleverbot (.+)$/i, :handle_cleverbot)

      # directly forward the latest incoming message to cleverbot and
      #   send cleverbot's response to the chat channel
      def handle_cleverbot(payload)
        clever_input = payload.matches.last

        payload.reply ask_cleverbot(clever_input)
      end

      def ask_cleverbot(question)
        client.say question
      end

      # manage a persistent connection to the Clever API throughout the lifecycle
      #   of each request
      def client
        @_client ||= Cleverbot.new(config.cleverbot_user, config.cleverbot_key)
      end

      Lita.register_handler(self)
    end
  end
end
