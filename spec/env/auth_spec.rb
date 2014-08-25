require 'spec_helper'

describe Plat::Env do
  it 'sets authentication keys for AWS to the provided values' do
    env = Plat::Env.new 
    env.configure do |c|
      c.aws_access_key_id = "ID"
      c.aws_secret_access_key = "SECRET"
    end
    expect( env.aws_auth[:access_key_id] ).to eq "ID"
    expect( env.aws_auth[:secret_access_key] ).to eq "SECRET"
  end
end