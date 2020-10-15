#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
module Lita
  module Handlers
    class ImgflipMemes < Handler
      Lita.register_handler(self)

      route /^(aliens)\s+(.+)/i, :make_meme, command: true,
        help: 'Aliens guy meme'

      def make_meme(message)
        template_id = 101470
        username = ENV.fetch('IMGFLIP_USERNAME', 'redacted')
        password = ENV.fetch('IMGFLIP_USERNAME', 'redacted')

        # generalize me
        # figure out when i might have multiple matches
        #   instead of just :first
        meme_name, text0, text1 = message.matches.first
        api_url = 'https://api.imgflip.com/caption_image'
        result = http.post api_url, {
          template_id: template_id,
          username: username,
          password: password,
          text0: text0,
          text1: text1
        }

        # clean me up
        image = JSON.parse(result.body).fetch("data").fetch("url")
        message.reply image
      end
    end
  end
end
