#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
# from lita-imgflip-memes/spec/lita/handlers/imgflip_memes_spec.rb
let(:jpeg_url_match) { /http.*\.jpg/i }

describe ':pull_image' do
  it 'returns a jpeg url' do
    aliens_template_id = 101470
    result = subject.pull_image(aliens_template_id, 'hello', 'world')

    expect(result).to match(jpeg_url_match)
  end
end
