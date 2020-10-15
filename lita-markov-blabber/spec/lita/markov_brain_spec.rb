#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'

describe Lita::MarkovBrain do
  # connect a sample corpus folder from the ./dict folder
  #   of this repository
  let(:test_inputs_path) { File.join(__dir__, '..', '..', 'dict') }

  describe 'given a short file full of words' do
    # load up a brain using the test corpus supplied above
    subject { Lita::MarkovBrain.new(inputs_path: test_inputs_path) } 

    # confirm basic functionality
    it "can generate n words on demand" do
      n = rand(1..100)
      result = subject.generate_n_words(n)

      expect(result.split.count).to eq(n)
    end

  end

end
