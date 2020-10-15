#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'
require 'ostruct'
require 'date'

describe Lita::CommanderMiddleware do
  # More setup than usual here to prepare a list of
  #   dummy web sockets to test against
  let(:handler) { double 'handler' }
  let(:result) { subject.build({}) }
  let(:open_sockets) { [] }
  let(:a_socket) { double 'a web socket' }

  # Test subject is a new commander with the above dummy sockets
  #   preloaded
  subject { Lita::CommanderMiddleware.new(open_sockets: open_sockets) }

  # Confirm the builder method returns a callable object itself.
  #   To do otherwise would render it unusable by the calling code.
  it 'returns a lambda' do
    result = subject.build
    expect(result.is_a?(Proc)).to be_truthy
  end

  # Validate basic happy-path functionality for incoming new
  #   client websocket connections
  context 'adding a new client' do
    before { Faye::WebSocket.stub(:new).and_return(a_socket) }
    let(:result) { subject.build_socket(nil) }

    it 'builds websockets on demand' do
      expect(result).to eq(a_socket)
    end

    it 'adds the new socket to :open_sockets' do
      expect(open_sockets).to include(result)
    end
  end

  # Validate "client said goodbye!" behaviors
  context 'client disconnects' do
    let(:event) { double 'socket event' }
    before { a_socket.stub(:send) }
    before { event.stub(:code) }
    before { event.stub(:reason) }

    it 'removes the client from :open_sockets' do
      result = subject.close_socket(a_socket, event)
      expect(result).to be_nil
      expect(open_sockets).to_not include(a_socket)
    end

    it 'logs to debug' do
      expect(Lita.logger).to receive(:debug).exactly(2).times
      subject.close_socket(a_socket, event)
    end
  end

  # Validate "client says hi!" behavior
  it 'acknowledges messages from clients' do
    event = OpenStruct.new(data: 'This is a message!')
    a_socket.stub(:send)
    expect(a_socket).to receive(:send)
    subject.handle_message(a_socket, event)
  end
end
