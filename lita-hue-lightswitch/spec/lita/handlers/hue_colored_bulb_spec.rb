#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "spec_helper"

describe HueColoredBulb do
  let(:bulb_name) { 'Bloom' }
  subject { described_class.new(bulb_name) }

  it 'can turn on and off' do
    subject.on!
    subject.off!
  end
  it 'has a list of colors' do
    actual = subject.colors
    expect(actual.first).to eq('red')
    expect(actual).to include('azure')
  end

  context 'setting a color' do
    it 'can be colored cyan' do
      expect{subject.set_color 'cyan'}.to_not raise_error
    end

    it 'cannot be colored burnt sienna' do
      expect{subject.set_color 'burnt_sienna'}.to raise_error(ArgumentError)
    end
  end

  context 'color hue estimations' do
    it 'has red at 0 hue' do
      actual = subject.hue_for_color 'red'
      expect(actual).to eq(0)
    end

    it 'has green at approximately 21k hue' do
      actual = subject.hue_for_color 'green'
      # absolute value of hue_for_color('green') should be within 1000
      # of the 21,000 approximation specified here.
      delta = (actual - 21000).abs
      expect(delta < 1000).to be_truthy
    end

    it 'has blue at approximately 44k hue' do
      actual = subject.hue_for_color 'blue'
      delta = (actual - 44000).abs
      expect(delta < 1000).to be_truthy
    end
  end

  context 'color wheel demo' do
    it 'displays each color exactly once' do
      n = subject.colors.count
      expect(subject.light).to receive(:hue=).exactly(n).times
      subject.demo(0.0001)
    end
  end
end
