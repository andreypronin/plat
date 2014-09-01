require 'spec_helper'
require 'tempfile'

describe Plat::Role do
  before(:each) do
    class TestRole < Plat::Role::Basic
    end
    Plat::Role.register :testtesttest, TestRole
  end
  let(:the_layout) { Plat::Layout.new }
  it 'allows registering role classes' do
    expect(Plat::Role.registered_types[:testtesttest]).to eq TestRole
  end
  it 'creates correct role instances' do
    {
      "some role" => Plat::Role.create( the_layout, "some role", { type: :testtesttest }), # explicit type specification
      "testtesttest" => Plat::Role.create( the_layout, "testtesttest", {})                 # implicit type from role
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

describe Plat::Layout do
  let(:roles_spec) { Hash("cpu" => { count: 10 }, "db" => { count: 20 }) }
  let(:roles_sio) { StringIO.new(roles_spec.to_yaml) }

  it 'allows loading roles from hash' do
    layout = Plat::Layout.new( roles: roles_spec )
    expect(layout.roles["cpu"]).to be_a Plat::Role::Cpu
    expect(layout.roles["cpu"].count).to eq 10
    expect(layout.roles["db"]).to be_a Plat::Role::Db
    expect(layout.roles["db"].count).to eq 20
  end

  it 'allows loading roles from StringIO' do
    layout = Plat::Layout.new( roles: roles_sio )
    expect(layout.roles["cpu"]).to be_a Plat::Role::Cpu
    expect(layout.roles["cpu"].count).to eq 10
    expect(layout.roles["db"]).to be_a Plat::Role::Db
    expect(layout.roles["db"].count).to eq 20
  end
  
  it 'allows loading roles from an array of sources, later sources take precendence' do
    roles_spec1 = roles_spec.clone
    roles_spec1.delete("cpu")
    roles_spec1["db"][:count] = 40

    layout = Plat::Layout.new( roles: [roles_sio, roles_spec1] )
    expect(layout.roles["cpu"]).to be_a Plat::Role::Cpu
    expect(layout.roles["cpu"].count).to eq 10
    expect(layout.roles["db"]).to be_a Plat::Role::Db
    expect(layout.roles["db"].count).to eq 40
  end

  it 'allows loading roles from File/IO' do
    layout1 = nil
    layout2 = nil
    layout3 = nil
    f = Tempfile.new("test_roles.yaml")
    begin
      f << roles_spec.to_yaml
      f.open
      layout1 = Plat::Layout.new( roles: f )
      layout2 = Plat::Layout.new( roles: f.path )
      File.open( f.path ) do |real_f|
        layout3 = Plat::Layout.new( roles: real_f )
      end
    ensure
      f.close
      f.unlink
    end
    expect(layout1).not_to be_nil
    expect(layout2).not_to be_nil
    expect(layout3).not_to be_nil
    [ 
      layout1,
      layout2,
      layout3
    ].each do |layout|
      expect(layout.roles["cpu"]).to be_a Plat::Role::Cpu
      expect(layout.roles["cpu"].count).to eq 10
      expect(layout.roles["db"]).to be_a Plat::Role::Db
      expect(layout.roles["db"].count).to eq 20
    end
  end
end