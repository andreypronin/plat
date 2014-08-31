require 'spec_helper'

describe Plat::Role::Cpu do
  let(:default_options) { Hash.new }
  let(:layout) { Plat::Layout.new }
  let(:subject) { Plat::Role.create(layout,:cpu,default_options) }
  
  it 'reaches AWS EC2 (smoke test)' do
    expect{subject.ec2.instances.to_a}.not_to raise_error
  end
end