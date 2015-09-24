require File.expand_path('../../../spec_helper', __FILE__)

RSpec.describe Wechat::Api::Client do
  subject { described_class.new('APPID', 'APPSECRET') }

  before do
    subject.logger.level = Logger::DEBUG
  end

  it :refresh do
    token_body = '{"access_token":"ACCESS_TOKEN","expires_in":7200}'
    stub_request(:get, /token/).to_return(body: token_body)
    expect(subject.refresh).not_to be_nil
  end

  it :refresh_error do
    token_body = '{"errcode": 40013}'
    stub_request(:get, /token/).to_return(body: token_body)
    expect { subject.refresh }.to raise_error(Wechat::Api::ResponseError)
  end

  it :refresh_token_error do
    token_body = '{"errcode": 40001}'
    stub_request(:get, /token/).to_return(body: token_body)
    expect { subject.refresh }
      .to raise_error(Wechat::Api::AccessTokenExpiredError)
  end

  it :access_token do
    token_body = '{"access_token":"ACCESS_TOKEN","expires_in":7200}'
    expect(File).to receive(:read).and_return(token_body)
    expect(subject.access_token).to eq('ACCESS_TOKEN')
  end

  it :get_twice do
    expect(subject).to receive(:access_token).twice.and_return('Token')
    expect(subject).to receive(:refresh).and_return('Token')
    stub_request(:get, /some/)
      .with(query: { access_token: 'Token' })
      .to_return(body: '{"errcode": 40001}').then
      .to_return(body: '{}')
    subject.get 'some'
  end

  it :post do
    expect(subject).to receive(:access_token).and_return('Token')
    stub_request(:post, /some/)
      .with(query: { access_token: 'Token' })
      .to_return(body: '{}')

    subject.post 'some', '{}'
  end
end
