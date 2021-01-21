require File.expand_path('../../../spec_helper', __FILE__)

RSpec.describe Wechat::Api::Util do
  subject { Wechat::Api::Client.new('APPID', 'APPSECRET') }

  before do
    subject.logger.level = Logger::DEBUG
  end

  it :js_config do
    allow(SecureRandom).to receive(:hex).and_return('Wm3WZYTPz0wzccnW')
    allow_any_instance_of(Time).to receive(:to_i).and_return(1414587457)
    allow(subject).to receive(:js_ticket).and_return('expires_in' => 7200, 'ticket' => 'sM4AOVdWfPE4DxkXGEs8VMCPGGVi4C3VM0P37wVUCFvkVAy_90u5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcHKP7qg')
    js = subject.js_config(url: 'http://mp.weixin.qq.com?params=value')
    expect(js).not_to be_nil
    expect(js).to include(signature: '0f9de62fce790f9a083d5c99e95740ceb90c27ed')
    expect(js).to have_key :appId
  end
end
