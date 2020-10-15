#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'open3'

module Lita
  module Handlers
    class VersionCheck < Handler
      # Simple route that responds to `lita version check` and nothing else.
      route(/^version check$/i, :check_version, command: true)

      # Executes a shell command on the host operating system and returns
      #   a combined STDOUT + STDERR string.
      #
      # WARNING: Don't let end users pass arbitrary text to this method!
      #   Also don't run Lita as a privileged user if you can help it.
      def exec_cmd(cmd)
	result, _ = Open3.capture2e(cmd)
	result
      end

      # Fetch the SHA representing the current git commit in this repository:
      #   e.g. fc648e78f54a74ca92a82d0ff77a9151fcf8e373
      def git_sha
	exec_cmd("git rev-parse HEAD").strip
      end

      # Asks the bundle command which version of lita-version-check you're
      #   running.
      #
      #   e.g. lita-version-check 0.1.0
      #
      def gemspec_version
	# - list all installed gems in this context and filter for the one named
	#   version check,
	# - strip out all characters other than alphanumerics and . - and space.
	# - trim leading and trailing whitespace
	# - split on whitespace
	# - join the split tokens back together with a uniform single space
	exec_cmd("bundle list | grep lita-version-check")
	  .gsub(/[^A-Za-z0-9\.\- ]/i, '') 
	  .strip
	  .split
	  .join(' ')
      end

      # Fetch the short-form repository URL of this git repo e.g.
      #   git@github.com:dpritchett/ruby-bookbot.git
      def git_repository_url
	exec_cmd("git config --get remote.origin.url").strip
      end

      # Builds a string demonstrating the three version checking methods
      #   constructed in this chapter: git sha, git repo URL, and gem version.
      #
      def check_version(message)
	message.reply [
	  "My git revision is [#{git_sha}].",
	  "My repository URL is [#{git_repository_url}].",
	  '<<<>>>',
	  "Brought to you by [#{gemspec_version}]."
	].join("\n")
      end

      # Simple echo method that exists to give us a simple test for confirming
      #   that the command executor works as expected.
      def echo_test(message="hi")
	exec_cmd "echo #{message}"
      end

      Lita.register_handler(self)
    end
  end
end
