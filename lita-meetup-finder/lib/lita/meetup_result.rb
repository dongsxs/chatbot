#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
module Lita
    class MeetupResult
        def initialize(raw_result)
            @raw_result = raw_result

            @name = raw_result.fetch('name')
            @url = raw_result.fetch('event_url')
            @group_name = raw_result.fetch('group').fetch('name')
        end

        # expose instance variables as attribute getters
        attr_reader :raw_result, :name, :url, :group_name

        # Human readable start time for the event
        #   Raw time:   1541941200000 
        #   Human time: Sun Nov 11 07:00:00 2018
        def start_time
            # API results are in milliseconds since the unix epoch
            epoch_msec = raw_result.fetch('time')
            epoch_sec = epoch_msec / 1000

            Time.at(epoch_sec).ctime
        end

        def tagline
            "#{name} >> Group: #{group_name} >> #{start_time} >> #{url}"
        end
    end
end