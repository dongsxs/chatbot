#---
# Excerpted from "Build Chatbot Interactions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/dpchat for more book information.
#---
require 'spec_helper'
require 'date'

describe Lita::Handlers::SonosCommander, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  subject { described_class.new(robot) }

  # Validate handling of expected web routes AND chat routes
  describe 'routes' do
    it {
      is_expected.to route_http(:get, '/sonos/listen')
        .to(:websocket_creator)
    }

    it {
      is_expected.to(route('Lita play url http://zombo.com')
        .to(:handle_sonos_play_url))
    }
    it {
      is_expected.to(route('Lita speak words i like turtles')
        .to(:handle_sonos_say_text))
    }

    # Confirm "lita is ready!" event triggers the websocket setup
    it { is_expected.to route_event(:loaded).to(:register_faye) }
  end

  describe 'sending messages to clients' do
    # Hook up a dummy socket to send messages to a dummy client
    let(:client) { double('socket client') }
    before { subject.stub(:sockets).and_return [client] }

    # Confirm socket client receives a command when Lita is asked to
    #   play a URL
    it 'should :send some commanding json to the client' do
      expect(client).to receive(:send).with(/play_url.+http.+volume/)

      subject.play_url 'http://bana.nas'
    end

    # Confirm the payload sent to socket client looks like a command
    it 'should :send some commanding json to the client' do
      expect(client).to receive(:send).with(/play_text.+turtles.+volume/)

      subject.say_text 'i like turtles'
    end

    # End-to-end test that confirms chat users are able to speak
    #   commands which are sent to the Sonos commander apparatus.
    it 'can grab a message from chat and store it' do
      send_message 'lita speak words i like turtles'
      response = replies.last

      # Confirms graceful handling of "command received when no
      #   users are connected" use case.
      expect(response).to match(/No clients found/i)
    end
  end

  # Validate behaviors of Lita's list of connected socket clients
  describe 'socket registry' do
    let(:sockets) { subject.sockets }
    it 'has a socket registry shared amongst instances of the handler' do
      sockets << 'banana'
      another_one = Lita::Handlers::SonosCommander.new({})

      expect(another_one.sockets).to include('banana')
    end

    it 'exposes the socket registry as an array' do
      canary = rand(10_000).to_s
      sockets << canary
      expect(sockets).to include(canary)

      sockets.delete_if { |socket| socket.eql? canary }
      expect(sockets).to_not include(canary)
    end
  end

  # Confirm cmomand serialization behavior: Your desires are packaged as JSON to 
  #   be sent across the wire to connected clients.
  describe 'text serializer' do
    it 'creates a json payload' do
      result = subject.serialize(command: 'phone_call', text: 'call your mother')

      deserialized = JSON.parse(result)

      expect(deserialized.fetch('command')).to eq 'phone_call'
      expect(deserialized.dig('data', 'volume')).to_not be_falsey
    end
  end

  # Confirm Lita's middleware list receives a Commander for future use
  #   handling incoming websocket connection attempts.
  describe 'socket middleware registration' do
    let(:middlewares) { double 'middlewares' }
    before { subject.stub(:middleware_registry).and_return(middlewares) }

    let(:commander) { double 'commander' }
    before { Lita::CommanderMiddleware.stub(:build).and_return(commander) }

    it 'should register the commander middleware' do
      expect(middlewares).to receive(:use).with(commander)

      subject.register_faye(nil)
    end
  end

  # Validates 
  describe ':websocket_creator' do
    let(:request) { double 'request' }
    let(:request_env) { double 'request' }
    let(:middleware) { double 'middleware' }
    let(:middlewares) { double 'middlewares' }

    before do
      subject.stub_chain(:middleware_registry)
        .and_return([middlewares])
      middlewares.stub(:middleware).and_return middleware
      request.stub(:env).and_return(request_env)
    end

    it 'passes incoming any request environments to registered middlewares' do
      expect(middleware).to receive(:call).with(request_env)
      subject.websocket_creator(request, nil)
    end
  end
end
