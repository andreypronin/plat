require 'spec_helper'

describe Plat::Env do
  it 'sets authentication keys for AWS to the provided values' do
    env = Plat::Env.new("test")
    env.aws_access_key_id = "ID"
    env.aws_secret_access_key = "SECRET"
    
    expect( env.aws_auth[:access_key_id] ).to eq "ID"
    expect( env.aws_auth[:secret_access_key] ).to eq "SECRET"
  end
  it 'includes all required components in resource name' do
    env = Plat::Env.new("EnvName")
    env.name_prefix = "some-prefix"
    env.app_name = "The Application"
    
    expect( env.resource_name("myrole",9956) ).to include("EnvName","some-prefix","The_Application","myrole","9956")
  end
end