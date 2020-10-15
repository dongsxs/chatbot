#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
def pull_image(template_id, line1, line2)
  username = ENV.fetch('IMGFLIP_USERNAME', 'redacted')
  password = ENV.fetch('IMGFLIP_USERNAME', 'redacted')

  api_url = 'https://api.imgflip.com/caption_image'
  result = http.post api_url, {
    template_id: template_id,
    username: username,
    password: password,
    text0: line1,
    text1: line2
  }

  # clean me up
  image = JSON.parse(result.body).fetch("data").fetch("url")
end
