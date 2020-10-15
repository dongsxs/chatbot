#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'

describe Lita::Handlers::MarkovBlabber, lita_handler: true do

  # e.g. lita-markov-blabber/spec/dict/moby-dick-sample.txt
  let(:test_inputs_path) { File.join(__dir__, '..', '..', 'dict') }

  let(:robot) { Lita::Robot.new(registry) }

  # preload a test inputs path to your already started markov blabber module
  before do
    robot.config.handlers.markov_blabber.markov_inputs_path = test_inputs_path
  end

  # manually set up a new lita bot as the system under test
  #   since the default behavior can't quite link this together
  subject { described_class.new(robot) }

  # test base case of generating N words on demand
  describe ':gibberish' do
    it 'generates lots of words' do
      result = subject.gibberish
      word_count = result.split.count
      expect(word_count > 4).to be_truthy
      expect(word_count < 30).to be_truthy
    end
  end

  # confirm variations on "words come in, words go out"
  describe 'blabber' do
    it 'answers arbitrary inputs' do
      lyrics = ['welcome to the jungle',
                'take me down to the paradise city',
                "shed a tear cause i'm missing you"]

      lyrics.each do |lyric|
        send_message lyric
        response = replies.last
        word_count = response.split.count

        expect(word_count > 4).to be_truthy
        expect(word_count < 30).to be_truthy
      end
    end
  end
end
