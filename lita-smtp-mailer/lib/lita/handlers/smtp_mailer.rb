#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'mail'
require 'pry'

module Lita
  module Handlers
    class SmtpMailer < Handler
      Lita.register_handler(self)

      config :smtp_server, default: 'smtp.gmail.com'
      config :smtp_password, default: ENV['SMTP_PASSWORD']
      config :smtp_username, default: ENV['SMTP_USERNAME']
      config :smtp_from_address, default: ENV['SMTP_FROM_ADDRESS']
      config :smtp_auth, default: 'plain'
      config :smtp_port, default: 587
      config :smtp_enable_tls_auto, default: true

      # non-whitespace-chars@non-whitespace-chars
      SIMPLE_EMAIL_REGEX = /\S+@\S+/

      route /^email\s+(#{SIMPLE_EMAIL_REGEX})\s+(.+)$/i,
        :send_email,
        command: true,
        help: { 'email address@domain.com message body goes here' => 'Sends an email' }

      def configure_smtp!
        options = { :address              => config.smtp_server,
                    :port                 => config.smtp_port,
                    :user_name            => config.smtp_username,
                    :password             => config.smtp_password,
                    :authentication       => config.smtp_auth,
                    :enable_starttls_auto => config.smtp_enable_tls_auto }

        Mail.defaults do
          delivery_method :smtp, options
        end
      end

      def deliver_email(to_address:, message_body:, from_address: config.smtp_from_address)
        configure_smtp!

        result = Mail.deliver do
          to to_address
          from from_address
          subject "[Lita bot] #{message_body.first(64)}"
          body message_body
        end
      end

      def send_email(response)
        to_address, message_body = response.matches.last
        result = deliver_email to_address: to_address, message_body: message_body
        response.reply "Sent email to [#{to_address}]."
      end
    end
  end
end
