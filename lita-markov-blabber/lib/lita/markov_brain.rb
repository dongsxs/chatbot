#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# include the markov gem to provide our core functionality
require 'marky_markov'

class Lita::MarkovBrain
  # define a custom error class for easier debugging
  NoBrainInputsFound = Class.new(StandardError)

  # build and load a new in-memory brain from the input text.
  #   inputs_path is a *required* input
  def initialize(inputs_path:)
    @inputs_path = File.absolute_path(inputs_path)
    @dictionary = ::MarkyMarkov::TemporaryDictionary.new
    load_brain!
  end

  # given a number N, return a string with N words
  def generate_n_words(n)
    dictionary.generate_n_words(n)
  end

  private

  # expose .dictionary and .inputs_path 
  #   as private getters for this class
  attr_reader :dictionary, :inputs_path

  # Note the short-circuit behavior if the brain is already loaded.
  # Raise the custom exception if no suitable inputs are identified.
  def load_brain!
    return unless dictionary.dictionary.empty?
    text_files_path = inputs_path + '/*.txt'

    files = Dir[text_files_path]

    if files.none?
      raise(NoBrainInputsFound,
            "No markov input files found at [#{text_files_path}]")
    end

    Dir[text_files_path].each do |file|
      load_dictionary(file)
    end
  end

  def load_dictionary(path)
    logger.debug "Loading Markov input text at: [#{path}]"
    dictionary.parse_file path
  end

  # Redefine a local logger variable so we can easier test this class
  #   in isolation without having to monkeypatch Lita.logger later.
  def logger
    Lita.logger
  end
end
