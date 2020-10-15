#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'

describe Lita::Handlers::CleverbotDemo, lita_handler: true do
  # verify basic chat routes are matched
  it { is_expected.to route('Lita cleverbot hello') }
  it { is_expected.to_not route('Lita clever hello') }

  # sanity check on basic "questions are answered" function
  describe 'ask cleverbot a question' do
    context 'given an english input' do
      let(:question) { 'hi cleverbot' }
      let(:result) { subject.ask_cleverbot question }

      it 'fetches a response with more than one word' do
        word_count = result.split.count

        expect(word_count).to be > 1
        expect(result).to match(/\w+/)
      end
    end
  end

  # confirm end to end functionality - arbitrary text gets a response
  describe 'lita integration test' do
    it 'answers questions with cleverbot' do
      send_message 'Lita cleverbot hello cleverbot'

      expect(replies.last).to match(/\w+/)
    end
  end
end
