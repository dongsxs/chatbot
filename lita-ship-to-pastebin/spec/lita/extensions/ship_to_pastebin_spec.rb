#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'

describe Lita::Extensions::ShipToPastebin, lita: true do
  subject { Lita::Extensions::ShipToPastebin.new }

  # thanks webmock!
  before { stub_pastebin_calls! }

  it 'saves text to pastebin' do
    actual = subject.save_to_pastebin 'hey john', title: 'hey there john'

    # e.g. https://pastebin.com/Vi4Cgn6i
    expect(actual).to match(%r{^https:\/\/pastebin\.com\/[a-zA-Z0-9]+})
  end
end
