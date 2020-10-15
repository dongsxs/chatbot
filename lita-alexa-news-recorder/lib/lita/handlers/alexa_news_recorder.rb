#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'pry'
require 'json'

module Lita
  module Handlers
    class AlexaNewsRecorder < Handler
      http.post '/alexa/recorder', :record_message

      # Rack::Request, Rack::Response
      def record_message(request, response)
        Lita.logger.debug(request)
        Lita.logger.debug(request.body.string)

        message = extract_message(request.body.string)
        robot.trigger(
          :save_alexa_message,
          username: 'Alexa News Recorder',
          message: message
        )

        response.write JSON.dump(alexa_response(message))
      end

      def extract_message(payload)
        parsed = JSON.parse(payload)

        value = parsed.dig('request', 'intent', 'slots', 'Message', 'value')

        raise ArgumentError if value.nil?
        value
      end

      def alexa_response(message)
        {
          "version": "1.0",
          "sessionAttributes": {
          },
          "response": {
            "outputSpeech": {
              "type": "PlainText",
              "text": "Added your message to Lita's flash briefing: #{message}"
            },
            "card": {
              "type": "Simple",
              "title": "Recorded flash message",
              "content": "Added your message to Lita's flash briefing: #{message}"
            },
            "shouldEndSession": true
          }
        }
      end

      Lita.register_handler(self)
    end
  end
end
