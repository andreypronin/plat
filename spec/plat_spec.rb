require 'spec_helper'

describe Plat do
  it 'has version (smoke test)' do
    expect(Plat::VERSION).to be_a(String)
  end
end