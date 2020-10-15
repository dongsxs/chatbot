#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'
require 'json'
require 'pry'

describe Lita::MeetupResult do
  let(:raw_results) { JSON.load(json_fixture).fetch('results') }

  it "has a fixture with 2 results" do
    expect(raw_results.count).to eq 2
  end

  context "Result parsing" do
    let(:parsed_results) { raw_results.map { |el| described_class.new el } }

    it "can parse the fixture's JSON input as MeetupResult objects" do
      expect(parsed_results.map(&:class).uniq).to eq [described_class]
    end

    context "accessor methods" do
      let(:result) { parsed_results.first }

      it 'parses group name' do
        expect(result.group_name).to eq "Memphis Outdoor Adventures"
      end

      it 'parses event name' do
        expect(result.name).to include 'Pinnacle Mountain'
      end

      it 'parses start time' do
        expect(result.start_time).to include 'Sun Nov 11'
      end

      it 'parses url' do
        expect(result.url.start_with? 'https://www.meetup.com/').to be_truthy
      end

      context 'human-friendly formatting' do
        let(:tagline) { result.tagline }
        fields = [:group_name, :name, :start_time, :url]

        fields.each do |field|
          it "tagline includes #{field}" do
            expected = result.send(field)
            expect(tagline.include? expected).to be_truthy
          end
        end
      end
    end
  end
end