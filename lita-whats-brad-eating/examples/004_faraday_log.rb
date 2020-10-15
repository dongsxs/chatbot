#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# load two gems to enable fetching and parsing of web content
pry(main)> require 'faraday'
true
pry(main)> require 'nokogiri'
true
pry(main)> raw_response = Faraday
  .get('https://whatsbradeating.tumblr.com').body;

pry(main)> parsed_response = Nokogiri.parse(raw_response)
# ... response snipped for brevity

pry(main)> parsed_response.class
Nokogiri::HTML::Document < Nokogiri::XML::Document
pry(main)> parsed_response.css('.post').first
# <Nokogiri::XML::Element:0x3fe00cd4a48c name="section"
#   attributes=[#<Nokogiri::XML::Attr:0x3fe00 name="class" value="post">]
#   children=[#<Nokogiri::XML::Text:0x3fe00a301a90 "\r\n
#   \r\n\r\n                                            \r\n
#   ">, #<Nokogiri::XML::Element:0x3fe00a3019dc name="
# ... remaining response snipped for brevity
