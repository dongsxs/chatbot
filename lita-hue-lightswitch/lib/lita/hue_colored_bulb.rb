#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# The hue gem is doing all the heavy lifting here, you're simply
#   wrapping it in some more beginner-friendly language.
require 'hue'

# Exposes basic on, off, and recolor commands for a single named Hue bulb
#   on the local network.
class HueColoredBulb
  # Note that the initializer only cares about a single named bulb
  #   and does not look around for other bulbs to care about.
  def initialize(name='Bloom')
    @client = Hue::Client.new

    # Your client likely has multiple bulbs attached, but here you're only
    #   going to want to find a single bulb that matches the supplied name.
    @light = @client.lights.select do |light|
      light.name == name
    end.first

    # No point continuing if the bulb can't be found by name.
    raise ArgumentError if @light.nil?
  end

  # The named light itself and the Hue client object are both worth reusing
  #   as instance variables
  attr_reader :light, :client

  # on! and off! methods are passed right through this API. They're plenty
  #   simple for your purposes as is.
  def on!
    light.on!
  end

  def off!
    light.off!
  end

  # Fun demo to spin through all named colors, one color every quarter second.
  def demo(sleep_seconds=0.25)
    colors.each do |color_name|
      self.set_color color_name
      sleep sleep_seconds
    end
  end

  # Hue's color coordinate system has about 64,000 distinct hues. For Lita
  #   purposes you're fine starting with these twelve familiar options.
  #
  # The colors are listed in ascending order of hue along the color wheel
  #   starting at red, moving clockwise up through green and blue,
  #   and looping back around to the starting point to end at the same
  #   red where they began.

  # Each color's corresponding hue number is one-twelfth of the circle's
  #   circumference higher than the previous color. If red is 0 then orange is
  #   65535 / 12 * 1, or 5461. Yellow is twice that at 10,922. Rose is 60,073.
  #                      [R]ed

  #             rose           orange

  #       magenta                    yellow

  #    violet                           chartreuse

  #       [B]lue                     [G]reen

  #             azure          aquamarine

  #                      cyan

  #
  def colors
    [
      'red', 'orange', 'yellow',           # red is 0
      'chartreuse', 'green', 'aquamarine', # green is 21,000
      'cyan', 'azure', 'blue',             # blue is 44,000
      'violet', 'magenta', 'rose'          # rose is about 60,000
    ]
  end

  # Take a color name like cyan, look up its hue on the 65000 point scale,
  #   and pass that number to the light's hue= method to recolor the light.
  def set_color(name)
    unless colors.include? name.downcase
      raise ArgumentError.new("I don't know that color!")
    end

    light.hue = hue_for_color(name)
  end

  # RGB color wheel from 0 to 65535:
  #   red is 0 (and 65535 because the wheel starts over at the end)
  #   green is ~21000
  #   blue is ~44000
  def hue_for_color(name)
    # green has an index of 4 in the colors array above
    color_index = colors.find_index(name)

    # each color is 65535 / 12 points "wide",
    #   which is 5461 points on this RGB color wheel.
    color_width = (max_color / colors.count).to_i

    # green's hue is thus 4 * 5461 = 21845.
    color_index * color_width
  end

  private
  # The hue gem has a built-in constant range to track the number of distinct
  #   color hues the system exposes for a given colored bulb, i.e. 2^16 or
  #   "16-bit" color.
  def max_color
    # 0..65535
    Hue::Light::HUE_RANGE.last
  end
end
