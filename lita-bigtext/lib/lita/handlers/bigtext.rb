#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'lita-ship-to-pastebin'

module Lita
  module Handlers
    class Bigtext < Handler
      config :pastebin_api_key, default: 'd88582e90ba06b60569dc55ab5b678ce'

      Lita.register_handler(self)

      route(/^bigtext/i,
            :hide_bigtext,
            command: true,
            help: {
              'bigtext' => 'gimme a wall of text hidden behind a pastebin URL'
            })

      def hide_bigtext(message)
        too_long = longtext
        url_placeholder = snip_text too_long
        message.reply url_placeholder
      end

      def snip_text(text)
        Lita::Extensions::ShipToPastebin.new.
          save_to_pastebin(text, api_key: config.pastebin_api_key)
      end

      def longtext
        (1..100).each.map do
          %w[able baker charlie delta echo alpha bravo hawaii].sample
        end.join(' ')
      end
    end
  end
end
