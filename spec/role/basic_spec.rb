require 'spec_helper'

require 'spec_helper'

describe Plat::Role::Basic do
  before(:each) do
    class TestRole < Plat::Role::Basic
    end
    Plat::Role.register :testtesttest, TestRole
  end
  let(:the_layout) { Plat::Layout.new( env: 'test') }
  it 'stores passed parameters' do
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78 })
    expect(role).to be_a TestRole
    expect(role.type).to eq :testtesttest
    expect(role.layout).to eq the_layout
    expect(role.role).to eq "some role"
    expect(role.options[:x]).to eq 78
  end
  it 'picks parameters for the right environment' do
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78, default: { x: 99 } })
    expect(role.options[:x]).to eq 99
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78, "default" => { x: 93 } })
    expect(role.options[:x]).to eq 93
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78, default: { x: 99 }, test: { x: 15 } })
    expect(role.options[:x]).to eq 15
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78, "default" => { x: 93 }, "test" => { x: 21 } })
    expect(role.options[:x]).to eq 21
  end
  it 'uses explicitly passed count' do
    role = Plat::Role.create(the_layout, "testtesttest", { count: 732 })
    expect(role.count).to eq 732
  end
  it 'converts count from strings and floats' do
    [
      Plat::Role.create(the_layout, "testtesttest", { count: "681" }),
      Plat::Role.create(the_layout, "testtesttest", { count: 681.7 }),
      Plat::Role.create(the_layout, "testtesttest", { count: "681.7" })
    ].each do |role|
      expect(role.count).to eq 681
    end
  end
  it 'sets count to 1 by default' do
    role = Plat::Role.create(the_layout, "testtesttest", {})
    expect(role.count).to eq 1
  end
  it 'does not allow incorrectly specified counts' do
    [
      Plat::Role.create(the_layout, "testtesttest", { count: 0 }),
      Plat::Role.create(the_layout, "testtesttest", { count: -1 }),
      Plat::Role.create(the_layout, "testtesttest", { count: Float::INFINITY }),
      Plat::Role.create(the_layout, "testtesttest", { count: [] }),
      Plat::Role.create(the_layout, "testtesttest", { count: {} }),
      Plat::Role.create(the_layout, "testtesttest", { count: { value: 100 } }),
      Plat::Role.create(the_layout, "testtesttest", { count: "one" }),
      Plat::Role.create(the_layout, "testtesttest", { count: nil })
    ].each do |role|
      expect{role.count}.to raise_error
    end
  end
  it 'prints role in inspect' do
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78 })
    expect(role.inspect).to include "role='some role'"
  end
  it 'prints itself as hash in to_s' do
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78 })
    template = { "some role" => { type: :testtesttest, x: 78 } }
    expect(role.to_s).to eq template.to_s
  end
  it 'uses the correct resource name' do
    role = Plat::Role.create(the_layout, "some role", { type: :testtesttest, x: 78 })
    expect(role.resource_name(17)).to eq the_layout.aws_resource_name("some role",17)
  end
end
