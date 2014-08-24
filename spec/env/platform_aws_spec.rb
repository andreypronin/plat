require 'spec_helper'

describe Plat::Env do
  let(:env) do
    { 
      platforms: {
        aws1: { provider: 'AWS', 
                aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
                aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] }
      }
    }
  end
  let(:env_bad) do
    { 
      platforms: {
        aws1: { provider: 'AWS', 
                aws_access_key_id: 'xxx', 
                aws_secret_access_key: 'yyy' }
      }
    }
  end
  let(:plat) { Plat::Env.new(env) }
  let(:plat_bad) { Plat::Env.new(env_bad) }
  it 'can access a correctly defined platform' do
    expect(plat.active?).to be_true
    expect(plat.valid?).to be_true
  end
  it 'fails to work with invalid credentials' do
    expect(plat.active?).to be_false
    expect(plat.valid?).to be_false
  end
end