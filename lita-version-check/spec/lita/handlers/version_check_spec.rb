#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "spec_helper"

describe Lita::Handlers::VersionCheck, lita_handler: true do
  # Minimal test to confirm that executing commands appears to be
  #   happening without throwing an exception.
  it "Should successfully execute and echo command and return the input" do
    greeting = "Hello there!"
    result = subject.echo_test(greeting)
    expect(result.strip).to eq(greeting)
  end

  describe "lookup commands" do
    it "finds a git sha" do
      result = subject.git_sha
      expect(result.strip).to eq(`git rev-parse HEAD`.strip)
    end
    
    it "finds a gem version from the bundle list command" do
      result = subject.gemspec_version
      expect(result.include? 'lita-version-check').to be_truthy
    end

    it "finds a git repo URL" do
      result = subject.git_repository_url
      # repo url subject to change but that's where the code for this 
      #   book is publicly posted.
      expect(result).to match(/git@github.com/)
    end
  end
end
