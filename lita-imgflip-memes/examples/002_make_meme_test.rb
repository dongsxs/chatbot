#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "spec_helper"

describe Lita::Handlers::ImgflipMemes, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  subject { described_class.new(robot) }

  describe 'routes' do
    it { is_expected.to route("Lita aliens chat bots") }
  end

  describe ':make_meme' do
    it 'responds with an image URL' do
      send_message "Lita aliens chat bots"
      expect(replies.last).to match(/http/i)
    end
  end
end
