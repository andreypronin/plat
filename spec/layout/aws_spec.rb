require 'spec_helper'

describe Plat::Layout do
  it 'specifies options for AWS' do
    layout = Plat::Layout.new do |config|
      config.aws_access_key_id = "key-id"
      config.aws_secret_access_key = "big-secret"
    end
    expect(layout.aws_options).to be_a Hash
    expect(layout.aws_options.size).to eq 2
    expect(layout.aws_options[:access_key_id]).to eq "key-id"
    expect(layout.aws_options[:secret_access_key]).to eq "big-secret"
  end
  
  it 'builds AWS resource names' do
    layout1 = Plat::Layout.new do |config|
      config.app_name = "Super App"
      config.name_prefix = "ThePrefix"
      config.env = "My Env"
    end
    expect(layout1.aws_resource_name("NumbersCruncher",997)).to eq "ThePrefix-Super_App-My_Env-NumbersCruncher-997"
    
    layout2 = Plat::Layout.new # use defaults
    expect(layout2.aws_resource_name("Database")).to eq "Database-0"
  end
end

describe Plat::Layout do
  let(:subject) { Plat::Layout.new }
  it 'has required AWS configuration variables with correct default values' do
    expect(subject.configuration.param_names).to include :aws_access_key_id, :aws_secret_access_key, :env, :name_prefix, :app_name
    
    expect(subject.configuration.aws_access_key_id).to eq (ENV["AWS_ACCESS_KEY_ID"] || '???')
    expect(subject.configuration.aws_secret_access_key).to eq (ENV["AWS_SECRET_ACCESS_KEY"] || '???')
    expect(subject.configuration.env).to eq ''
    expect(subject.configuration.name_prefix).to eq ''
    expect(subject.configuration.app_name).to eq ''
  end
  it 'does not allow changing AWS configuration variables after initialization' do
    expect{subject.configuration.aws_access_key_id="new-id"}.to raise_error
    expect{subject.configuration.secret_access_key="new-secret"}.to raise_error
    expect{subject.configuration.env="new-env"}.to raise_error
    expect{subject.configuration.name_prefix="new-prefix"}.to raise_error
    expect{subject.configuration.app_name="new-name"}.to raise_error
  end
end
