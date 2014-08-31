require 'spec_helper'

require 'spec_helper'

describe Plat::Role::Basic do
  before(:each) do
    class TestRole < Plat::Role::Basic
    end
    Plat::Role.register :testtesttest, TestRole
  end
  it 'stores passed parameters' do
    role = Plat::Role.create("test-layout", "some role", { type: :testtesttest, x: 78 })
    expect(role).to be_a TestRole
    expect(role.type).to eq :testtesttest
    expect(role.layout).to eq "test-layout"
    expect(role.role).to eq "some role"
    expect(role.options[:x]).to eq 78
  end
  it 'uses explicitly passed count' do
    role = Plat::Role.create("test-layout", "testtesttest", { count: 732 })
    expect(role.count).to eq 732
  end
  it 'converts count from strings and floats' do
    [
      Plat::Role.create("test-layout", "testtesttest", { count: "681" }),
      Plat::Role.create("test-layout", "testtesttest", { count: 681.7 }),
      Plat::Role.create("test-layout", "testtesttest", { count: "681.7" })
    ].each do |role|
      expect(role.count).to eq 681
    end
  end
  it 'sets count to 1 by default' do
    role = Plat::Role.create("test-layout", "testtesttest", {})
    expect(role.count).to eq 1
  end
  it 'does not allow incorrectly specified counts' do
    [
      Plat::Role.create("test-layout", "testtesttest", { count: 0 }),
      Plat::Role.create("test-layout", "testtesttest", { count: -1 }),
      Plat::Role.create("test-layout", "testtesttest", { count: Float::INFINITY }),
      Plat::Role.create("test-layout", "testtesttest", { count: [] }),
      Plat::Role.create("test-layout", "testtesttest", { count: {} }),
      Plat::Role.create("test-layout", "testtesttest", { count: { value: 100 } }),
      Plat::Role.create("test-layout", "testtesttest", { count: "one" }),
      Plat::Role.create("test-layout", "testtesttest", { count: nil })
    ].each do |role|
      expect{role.count}.to raise_error
    end
  end
  it 'prints role in inspect' do
    role = Plat::Role.create("test-layout", "some role", { type: :testtesttest, x: 78 })
    expect(role.inspect).to include "role='some role'"
  end
  it 'prints itself as hash in to_s' do
    role = Plat::Role.create("test-layout", "some role", { type: :testtesttest, x: 78 })
    template = { "some role" => { type: :testtesttest, x: 78 } }
    expect(role.to_s).to eq template.to_s
  end
end
