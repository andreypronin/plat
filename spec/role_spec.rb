require 'spec_helper'

describe Plat::Role do
  before(:each) do
    class TestRole < Plat::Role::Basic
    end
    Plat::Role.register :testtesttest, TestRole
  end
  it 'allows registering role classes' do
    expect(Plat::Role.registered_types[:testtesttest]).to eq TestRole
  end
  it 'creates correct role instances' do
    {
      "some role" => Plat::Role.create( nil, "some role", { type: :testtesttest }), # explicit type specification
      "testtesttest" => Plat::Role.create( nil, "testtesttest", {})                 # implicit type from role
    }.each_pair do |role_name, role|
      expect(role).to be_a TestRole
      expect(role.type).to eq :testtesttest
      expect(role.role).to eq role_name
    end
  end
  it 'creates CPU role instance by default' do
    layout = Plat::Layout.new
    role = Plat::Role.create layout, "some role", {}
    expect(role.type).to eq :cpu
    expect(role.role).to eq "some role"
  end
end