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
  let(:jpeg_url_match) { /http.*\.jpg/i }
  let(:aliens_template_id) { 101470 }

  subject { described_class.new(robot) }

  describe 'routes' do
    it { is_expected.to route("Lita aliens chat bots") }
  end

  describe ':pull_image' do
    it 'returns a jpeg url' do
      result = subject.pull_image(aliens_template_id, 'hello', 'world')

      expect(result).to match(jpeg_url_match)
    end
  end

  describe ':make_meme' do
    after { send_command "aliens chat bots" }
    it 'responds with an image URL' do
      send_message 'Lita aliens chat bots'
      expect(replies.last).to match(jpeg_url_match)
    end

    it 'can handle two-line inputs' do
      send_message 'lita one does not simply walk into mordor'
      expect(replies.last).to match(jpeg_url_match)
    end
  end

  describe ':extract_meme_text' do
    let(:matchers) { described_class.registered_templates }

    it 'can properly match no-first-line inputs' do
      matcher = matchers.select { |t| t.fetch(:template_id) == 101470 }.first
      pattern = matcher.fetch(:pattern)

      match_data = pattern.match 'aliens chat bots'
      result = subject.extract_meme_text match_data

      expect(result).to eql(['', 'chat bots'])
    end

    it 'can properly capture meme text that is part of the trigger' do
      matcher = matchers.select { |t| t.fetch(:template_id) == 61579 }.first
      pattern = matcher.fetch(:pattern)

      match_data = pattern.match 'one does not simply walk into mordor'
      result = subject.extract_meme_text match_data

      expect(result).to eql(['one does not simply', 'walk into mordor'])
    end
  end
end
