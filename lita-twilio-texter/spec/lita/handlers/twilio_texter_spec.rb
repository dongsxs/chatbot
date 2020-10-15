#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require "spec_helper"

describe Lita::Handlers::TwilioTexter, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  subject { described_class.new(robot) }
  
  describe ':text' do
    it { is_expected.to route("Lita text 12134441234 hi mom") }
    it { is_expected.to_not route("Lita text hi mom") }

    it 'sends texts' do
      send_message 'Lita text 19016052970 hey daniel'
      expect(replies.last).to eq('Sent message to 19016052970')
    end
  end

  describe ':client' do
    it 'should return a logged-in Twilio client' do
      clt = subject.client
      expect(clt.account_sid.empty?).to be_falsey
      expect(clt.auth_token.empty?).to be_falsey
    end
  end

  # dependent on my area code, naturally
  describe ':send_from_number' do
    it 'should return a Memphis-area phone number' do
      number = subject.send_from_number
      expect(number.start_with?('+1901')).to be_truthy
    end
  end

  describe ':send_twilio_sms' do
    it 'should work' do
      response = subject.send_twilio_sms(to: '+12135551234', body: 'hi from lita test')
      expect(response.error_code).to eq(0)
      expect(response.status).to eq("queued")
    end
  end
end


