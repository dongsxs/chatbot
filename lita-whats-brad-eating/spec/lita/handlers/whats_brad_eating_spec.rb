#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'
require 'pry'

describe Lita::Handlers::WhatsBradEating, lita_handler: true, vcr: true do
  let(:robot) { Lita::Robot.new(registry) }
  # cache web requests using VCR to limit web traffic from tests.
  #   also ensures consistent inputs for simpler testing.
  use_vcr_cassette

  subject { described_class.new(robot) }

  describe 'routes' do
    # confirm three variations on what's brad eating each trigger a response
    it { is_expected.to route("Lita what's brad eating") }
    it { is_expected.to route("Lita what's BRAD eating") }
    it { is_expected.to route("Lita what’s BRAD eating") }
  end

  # validate your basic HTML content fetching methods
  describe ':response' do
    let(:body) { subject.response.body }

    it "should be able to pull down some HTML from Brad's blog" do
      expect(body =~ /<html>/i).to be_truthy
    end

    it 'should include something that looks like an image tag' do
      expect(body =~ /img src/i).to be_truthy
    end

    it 'should include a caption' do
      expect(body.include?('caption')).to be_truthy
    end
  end

  # validate navigability of parsed web content
  describe ':parsed_response' do
    it 'should return a nokogiri object with a :css method we can search on' do
      expect(subject.parsed_response).to respond_to(:css)

      images = subject.parsed_response.css('img')
      expect(images.any?).to be_truthy
    end
  end

  describe ':first_post' do
    it 'finds exactly one node' do
      expect(subject.first_post.count).to eq(1)
    end

    it 'contains an image' do
      expect(subject.first_post.css('img').any?).to be_truthy
    end
  end

  describe ':image' do
    it 'finds at least one node' do
      attributes = subject.image.attributes
      expect(attributes.fetch('src').value).to include('http')

      # captions could be anything, let's just verify we got one
      expect(attributes.key?('alt')).to be_truthy
    end
  end

  # high-level "lita hears X and returns Y" end-to-end testing
  describe ':brad_eats' do
    it 'responds with a caption and an image URL' do
      send_message "Lita what's brad eating"
      expect(replies.last).to match(/\w+ >> http/i)
    end
  end
end
