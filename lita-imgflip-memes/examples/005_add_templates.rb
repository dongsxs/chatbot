#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# from lita-imgflip-memes/lib/lita/handlers/imgflip_memes.rb
TEMPLATES = [
  { template_id: 101470, pattern: /^aliens()\s+(.+)/i,
    help: 'Ancient aliens guy' },
  { template_id: 61579, pattern: /(one does not simply) (.+)/i,
    help: 'one does not simply walk into mordor' },
]

TEMPLATES.each do |t|
  route t.fetch(:pattern), :make_meme, command: true, help: t.fetch(:help)
end

def make_meme(message)
  match = message.matches.first
  raise ArgumentError unless match.size == 2
  line1, line2 = match

  templates = TEMPLATES.select do |t|
    t.fetch(:pattern) == message.pattern
  end
  template = templates.first

  raise ArgumentError if template.nil?

  image = pull_image(template.fetch(:template_id), line1, line2)

  message.reply image
end
