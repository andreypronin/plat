require 'spec_helper'

describe Plat::Env do
  it 'gets AWS keys from instance configuration, if present' do
    env = Plat::Env.new("test") do |c|
      c.aws_access_key_id = "ID"
      c.aws_secret_access_key = "SECRET"
    end
    expect( env.aws_access_key_id ).to eq "ID"
    expect( env.aws_secret_access_key ).to eq "SECRET"
    expect( env.aws_access_key_id ).not_to eq Plat::Env.configuration.aws_access_key_id
    expect( env.aws_secret_access_key ).not_to eq Plat::Env.configuration.aws_secret_access_key
  end
  it 'gets AWS keys from class configuration, if not provided for the specific instance' do
    env = Plat::Env.new("test")
    expect( env.aws_access_key_id ).to eq Plat::Env.configuration.aws_access_key_id
    expect( env.aws_secret_access_key ).to eq Plat::Env.configuration.aws_secret_access_key
  end
end