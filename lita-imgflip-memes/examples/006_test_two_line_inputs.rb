#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# from lita-imgflip-memes/spec/lita/handlers/imgflip_memes_spec.rb
it 'can handle two-line inputs' do
  send_message 'lita one does not simply walk into mordor'
  expect(replies.last).to match(jpeg_url_match)
end
