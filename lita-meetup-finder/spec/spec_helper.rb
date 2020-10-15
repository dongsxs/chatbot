#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "lita-meetup-finder"
require "lita/rspec"

# A compatibility mode is provided for older plugins upgrading from Lita 3. Since this plugin
# was generated with Lita 4, the compatibility mode should be left disabled.
Lita.version_3_compatibility_mode = false

require 'webmock/rspec'

# call me in a before block anywhere you're calling pastebin!
#   This will save you from fairly low-overhead API limits.
def stub_meetup_calls!
    stub_request(:get, /api.meetup.com/).
    with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Charset'=>'UTF-8',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
      }).
    to_return(status: 200, body: json_fixture, headers: {})
end

def json_fixture
  @_raw_json ||= open('./spec/fixtures/meetup_results.json')
end
