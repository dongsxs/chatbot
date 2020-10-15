#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'json'
require 'pry'
require 'ostruct'

module Lita
  class TravisWebhook < OpenStruct
    def initialize(parsed_json)
      @parsed_json = parsed_json
      @ostruct = super
    end

    attr_reader :parsed_json, :ostruct

    def self.from_string(raw_json)
      parsed = JSON.parse(raw_json)
      new parsed
    end

    def description
      status_message
    end

    def repo_name
      repository.fetch 'name'
    end

    def notification_string
      "*#{description}* [#{repo_name}] >> #{message} >> (#{compare_url})"
    end

    def working?
      %w[Pending Passed Fixed].include? status_message
    end

    def broken?
      !working?
    end

    def keys
      parsed_json.keys
    end
  end
end
