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
    class MakefileExecutor < Handler
      config :shipit_command, default: 'deploy'
      config :shipit_makefile_path, default: './examples'

      route /^(shipit|ship it)/i, :shipit_handler, command: true

      def shipit_handler(message)
	appname = message.matches.last
	result = ship_app
	message.reply result
      end

      # Passes a Makefile path and task name to make.
      #
      # Separates the file and the command in an attempt to limit the
      #   blast radius of potential malicious input. Note: you'll 
      #   probably want to further sanitize this before running it in
      #   production or giving it access to login secrets.
      #
      def ship_app
	`make --directory #{config.shipit_makefile_path} #{config.shipit_command}`
      end

      Lita.register_handler(self)
    end
  end
end
