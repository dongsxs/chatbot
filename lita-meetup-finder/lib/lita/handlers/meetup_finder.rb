#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# Load 3rd party meetup API client gem
require 'meetup_client'

module Lita
  module Handlers
    class MeetupFinder < Handler
      MeetupApiError = Class.new(StandardError)

      # Set these in your bot's lita_config.rb or via environment
      #   variable
      config :meetup_api_key, default: ENV['MEETUP_API_KEY']
      # note the 
      config :meetup_zip, default: ENV['MEETUP_ZIP']

      route(/^find meetup\s+(.+)$/i, :find_matching_meetup, command: true)

      def find_matching_meetup(message)
        # extract search term from user input
        search_term = message.matches.first
        # pass search term to meetup query method
        meetups = meetups_matching search_term

        # handle two basic outcomes: no results, 1+ results
        if meetups.none?
          message.reply "Sorry, no matching meetups found."
        else
          message.reply meetups.first&.tagline
        end
      end

      def client
        MeetupClient.configure do |meetup_config|
          # sets meetup config using value from lita config
          meetup_config.api_key = config.meetup_api_key
        end

        # store client rather than rebuilding on each call
        @_client ||= MeetupApi.new 
      end

      # query Meetup API for local meetups and return a
      #   list of matching MeetupResult objects
      def meetups_matching(search_text)
        query = build_search(search_text)

        begin
          response = client.open_events(query)
          results = response.fetch('results')
        rescue StandardError
          raise MeetupApiError.new(response)
        end

        # coerce an array of JSON-ish results into richer
        #   MeetupResult objects
        results.map { |r| MeetupResult.new(r) }
      end

      def build_search(search_text)
         {
          zip: config.meetup_zip,
          format: 'json',
          page: '5',
          text: search_text
        }
     end

      Lita.register_handler(self)
    end
  end
end