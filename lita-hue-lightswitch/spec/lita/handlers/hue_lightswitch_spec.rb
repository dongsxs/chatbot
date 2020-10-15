#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "spec_helper"

describe Lita::Handlers::HueLightswitch, lita_handler: true do
  subject { described_class.new(robot) }

  it { is_expected.to route("Lita hue color green") }
  it { is_expected.to route("Lita hue list_colors") }
  it { is_expected.to route("Lita hue off") }
  it { is_expected.to route("Lita hue on") }

  context 'using a dummy HueColoredBulb client' do
    let(:bulb) { double(:bulb) }
    before { subject.stub(:light).and_return bulb }
    # Intentionally deviating from the color list of the actual
    #   HueColoredBulb class for two reasons:
    #   - three colors make for simpler testing than 12
    #   - violating some of the numeric assumptions of the linked
    #       class might give us a more robust integration by assuming
    #       as little as necessary from this calling class.
    before { bulb.stub(:colors).and_return %w[red orange green] }

    it 'can turn off the bulb' do
      expect(bulb).to receive(:off!)
      actual = subject.hue_execute 'off'
      expect(actual).to match /Turning off/
    end
    it 'can turn off the bulb' do
      expect(bulb).to receive(:on!)
      actual = subject.hue_execute 'on'
      expect(actual).to match /Turning on/
    end

    it 'can list colors' do
      actual = subject.list_colors
      expect(actual).to include 'green'
      expect(actual).to include 'red'
      expect(actual).to include 'orange'
    end

    it 'can recolor the bulb' do
      new_color = bulb.colors.sample

      expect(bulb).to receive(:set_color)
      actual = subject.hue_execute "color", [new_color]
      expect(actual).to match /Setting color to #{new_color}/
    end
  end
end
