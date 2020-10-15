#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# from lita-whats-brad-eating/spec/lita/handlers/whats_brad_eating_spec.rb

describe 'routes' do
  # respond to this input:
  it { is_expected.to route("Lita what's brad eating") }
  # ... and also this one!
  it { is_expected.to route("Lita what's BRAD eating") }
end
