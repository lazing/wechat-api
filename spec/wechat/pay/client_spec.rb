require File.expand_path('../../../spec_helper', __FILE__)

RSpec.describe Wechat::Pay::Client do
  subject do
    described_class.new\
      'mch_id', 'wxappid',
      key: 'key', password: 'password', cert: 'cert',
      sign_key: 'sign_key'
  end

  it :trim_and_sort do
    expect(
      subject.send(:trim_and_sort, b: 2, c: 3, a: 1).values
    ).to start_with(1)
  end

  it :sign do
    expect(subject.send(:sign, b: 2, a: 1)).to have_key(:sign)
  end

  it :xml do
    expect(subject.send(:xml, b_1: 2, a: 1)).to match(/xml/)
  end
end
