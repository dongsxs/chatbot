#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'pry'

module Lita
  module Handlers
    class TravisAnnouncer < Handler

      config :travis_room, default: 'shell'

      http.post '/travis-announcer/travis', :parse_travis_webhook

      def parse_travis_webhook(request, response)
        raw_json = request.params.fetch('payload')
        travis_hook = Lita::TravisWebhook.from_string(raw_json)
        response.write handle_travis_build(travis_hook)
      end

      def handle_travis_build(hook)
        announce '*Broken build!*' if hook.broken?
        announce hook.notification_string
        hook.notification_string
      end

      def announce(message)
        Lita.logger.debug "Received announcement: #{message}"
        robot.send_message Source.new(room: '#general'), message
      end

      Lita.register_handler(self)
    end
  end
end
