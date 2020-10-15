#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'lita/markov_brain'

module Lita
  module Handlers
    class MarkovBlabber < Handler

      # e.g. lita-markov-brain/dict/name-of-input-file.txt
      DEFAULT_INPUTS_PATH = File.join __dir__, '..', '..', '..', 'dict'

      # allow end user to set their own input path at runtime
      config :markov_inputs_path, default: DEFAULT_INPUTS_PATH

      # redirect ALL otherwise unexpected chat messages to blabber
      on :unhandled_message, :blabber

      def blabber(payload)
        payload.fetch(:message).reply gibberish
      end

      def gibberish
        n = rand(5..20)
        gibberish = brain.generate_n_words n
      end

      private

      # define as a persistent class instance variable so you're not recreating
      #   and reloading the brain on each incoming message.
      def brain
        @@brain ||= Lita::MarkovBrain.new(inputs_path: config.markov_inputs_path)
      end

      Lita.register_handler(self)
    end
  end
end
