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

describe Lita::Handlers::MeetupFinder, lita_handler: true do
  subject { described_class.new(robot) }

  # Ask webmock to intercept any HTTP traffic to meetup API
  #  and respond with stored data instead of live data
  before { stub_meetup_calls! }

  let(:test_api_key) { nil } ##'14ae7022223d49b6e5e673d3e29' }
  let(:test_zip) { 38117 }

  # force config values to things you can test against
  before(:each) do
      # you'll need your own test API key here
      subject.config.meetup_api_key = test_api_key
      subject.config.meetup_zip = test_zip
  end

  describe 'routes' do
    # confirm three variations on what's brad eating each trigger a response
    it { is_expected.to route("Lita find meetup climbing") }
    it { is_expected.to_not route("Lita what’s for dinner?") }
  end

  describe ':build_search' do
      let(:search_text) { 'climbers' }
      let(:result) { subject.build_search search_text }

      it "should return a hash of Meetup search parameters" do
          expected = {
              zip: test_zip,
              format: 'json',
              page: '5',
              text: search_text
          }

          expect(result).to eq expected
      end
  end

  # validate your basic HTML content fetching methods
  describe ':meetup_search' do
    let(:climbers) { subject.meetups_matching 'climbers' }

    it "should find two results" do
      expect(climbers.count).to eq(2)
    end
  end

  # high-level "lita hears X and returns Y" end-to-end testing
  describe ':meetup_find' do
    it 'responds with a list of relevant meetups' do
      send_message "Lita find meetup climbing"
      expect(replies.last).to match(/\w+ >> http/i)
    end
  end
end
