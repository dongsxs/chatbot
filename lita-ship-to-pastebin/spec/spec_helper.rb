#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'lita-bigtext'
require 'lita/rspec'

# A compatibility mode is provided for older plugins upgrading from Lita 3. Since this plugin
# was generated with Lita 4, the compatibility mode should be left disabled.
Lita.version_3_compatibility_mode = false

require 'webmock/rspec'

# call me in a before block anywhere you're calling pastebin!
#   This will save you from fairly low-overhead API limits.
def stub_pastebin_calls!
  stub_request(:post, 'https://pastebin.com/api/api_post.php')
    .with(body: {
      'api_dev_key' => /[a-f0-9]+/,
      'api_option' => 'paste',
      'api_paste_expire_date' => '1D',
      'api_paste_code' => /\W+/,
      'api_paste_name' => /\W+/ },
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'User-Agent' => 'Faraday v0.15.0'
      })
    .to_return(
      status: 200,
      body: 'https://pastebin.com/6ig4DLUQ',
      headers: {}
    )
end
