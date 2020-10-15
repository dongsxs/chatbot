#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
[1] pry(main)> require 'hue'
=> true

[2] pry(main)> client = Hue::Client.new
=> #<Hue::Client:0x0000555b194f0b40
 @bridges=
  [#<Hue::Bridge:0x0000555b194f0140
    @client=#<Hue::Client:0x0000555b194f0b40 ...>,
    @id="001788fffe2c1ba4",
    @ip="10.0.0.106">],
 @username="redacted">

[3] pry(main)> client.lights.map(&:name)
=> ["Bottom lamp", "Middle lamp", "Top lamp", "Bloom"]

[4] pry(main)> bloom = client.lights.last
=> #<Hue::Light:0x0000555b1970a750
 @alert="none",
 @bridge=
  #<Hue::Bridge:0x0000555b194f0140
   @client=
    #<Hue::Client:0x0000555b194f0b40
     @bridges=[#<Hue::Bridge:0x0000555b194f0140 ...>],
     @username="CSvQNKCBeyLj-FRitKTPUNRD4tEmphZIjUG1VGp1">,
   @id="001788fffe2c1ba4",
   @ip="10.0.0.106",
   @lights=
#	   ... snipped for brevity ...

[6] pry(main)> ls bloom
Hue::TranslateKeys#methods: translate_keys  unpack_hash
Hue::EditableState#methods: 
  alert=       color_temperature=  hue=  on!  on?          set_xy
  brightness=  effect=             off!  on=  saturation=
Hue::Light#methods: 
  alert       color_mode         hue    name          reachable?
  bridge      color_temperature  id     name=         refresh   
  brightness  effect             model  point_symbol  saturation
instance variables: 
  @alert       @client      @hue    @name       @saturation       
  @bridge      @color_mode  @id     @on         @software_ver
  @brightness  @effect      @model  @reachable  @state            

# Change my bulb to a blue color
[7] pry(main)> bloom.hue = 44444
=> 44444

# Turn off my bulb
[8] pry(main)> bloom.off!
=> false

# Turn on my bulb
[9] pry(main)> bloom.on!
=> true
