require File.expand_path('../../../spec_helper', __FILE__)

RSpec.describe Wechat::Api::JsTicket do

  let(:client) { double(:client) }
  subject do
    Wechat::Api::JsTicket.new client
  end

  it :refresh do
    allow(client).to receive(:js_ticket).and_return('expires_in'=> 7200, 'ticket'=> 'bxLdikRXVbTPdHSM05e5u5sUoXNKd8-41ZO3MhKoyN5OfkWITDGgnr2fwJ0m9E8NYzWKVZvdVtaUgWvsdshFKA')
    subject.refresh
    expect(subject.ticket).not_to be_nil
    should_not be_expired
    expect(subject.expires_at).to be_a(Date)
  end

end
