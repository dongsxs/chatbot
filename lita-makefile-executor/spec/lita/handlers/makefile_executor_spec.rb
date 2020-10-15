#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "spec_helper"

describe Lita::Handlers::MakefileExecutor, lita_handler: true do
  let(:result) { subject.ship_app }

  # Simple test to confirm that this command executes the deploy
  #   command found in ./examples/Makefile
  it "executes a make command" do
    expect(result).to include('make')
    expect(result).to include('Entering directory')
    expect(result).to include('deploying now wow')
  end

  # End to end test from "lita hears this" to
  #   "lita responds with that"
  it "responds to lita shipit!" do
    send_command("shipit!")
    expect(replies.last).to include('deploying now')
  end
end
