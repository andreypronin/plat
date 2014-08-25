require 'spec_helper'

describe Plat::Env::Resource do
  it 'has :filestore registered as possible type' do
    env = Plat::Env.new("test") do |c|
      c.aws_access_key_id = "ID"
      c.aws_secret_access_key = "SECRET"
    end
    
    r = nil
    expect { r = Plat::Env::Resource.create(env,:filestore,"role") }.not_to raise_error
    expect(r).not_to be_nil
  end
  it 'doesn\'t have :bebebe registered as possible type' do
    env = Plat::Env.new("test") do |c|
      c.aws_access_key_id = "ID"
      c.aws_secret_access_key = "SECRET"
    end
    
    expect { Plat::Env::Resource.create(env,:bebebe,"role") }.to raise_error ArgumentError
  end
end