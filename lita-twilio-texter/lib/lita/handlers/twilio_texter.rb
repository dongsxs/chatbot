#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'twilio-ruby'
require 'pry'

module Lita
  module Handlers
    class TwilioTexter < Handler
      Lita.register_handler(self)

      config :twilio_sid,   default: ENV['TWILIO_ACCOUNT_SID']
      config :twilio_token, default: ENV['TWILIO_AUTH_TOKEN']

      route /^text\s+(\d+)\s+(.+)$/i,
        :send_text,
        command: true,
        help: { 'text 12135551234 hi mom' => 'texts "hi mom" to a fake number in California' }

      def client
        @_client ||= Twilio::REST::Client.new(
          config.twilio_sid,
          config.twilio_token
        )
      end

      def send_from_number
        client.incoming_phone_numbers.page.first.phone_number
      end

      def send_text(message)
        _, to, body = message.match_data.to_a
        results = send_twilio_sms(to: to, body: body)

        message.reply "Sent message to #{to}"
      end

      def send_twilio_sms(to:, body:)
        response = client.api.account.messages.create(
          from: send_from_number,
          to: to,
          body: body
        )
      end
    end
  end
end

