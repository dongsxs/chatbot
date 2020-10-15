#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# from lita-whats-brad-eating/lib/lita/handlers/whats_brad_eating.rb
route /^what's brad eating$/i,
  :brad_eats,		# name of handler method
  command: true,	# lita handles this as a direct command
  help: {		# help text for this method when you ask "lita help"
    "what's brad eating" => "latest post from brad's food tumblr"
  }


def brad_eats(response)
  response.reply 'Actual results coming soon!'
end
