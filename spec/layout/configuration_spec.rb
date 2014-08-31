require 'spec_helper'

describe Plat::Layout::Configuration do
  let(:subject) { Plat::Layout::Configuration.new }
  it 'returns itself from configure (smoke test)' do
    expect(subject.configure).to eq subject
  end
  it 'allows defining parameters' do
    class << subject
      param :test
    end
    expect(subject).to respond_to :test
    expect(subject).to respond_to :test=
    expect(subject.param_names).to include(:test)
  end
  
  it 'allows settings variables passed as a hash and/or block' do
    class << subject
      param :test1
      param :test2
    end
    subject.configure({test1: "something1"}) do |cfg|
      cfg.test2 = "something2"
    end
    expect(subject.test1).to eq "something1"
    expect(subject.test2).to eq "something2"
  end
  
  it 'allows specifying defaults' do
    class << subject
      param :test, default: "something3"
    end
    expect(subject.test).to eq "something3"
  end

  it 'allows restriciting value classes' do
    class << subject
      param :test, must_be: [Array,Hash]
    end
    expect{subject.test=[]}.not_to raise_error
    expect{subject.test={}}.not_to raise_error
    expect{subject.test=nil}.to raise_error
    expect{subject.test=""}.to raise_error
  end
  it 'allows restriciting value classes through duck typing' do
    class << subject
      param :test, must_respond_to: [:each_pair, :size]
    end
    expect{subject.test=[]}.to raise_error
    expect{subject.test={}}.not_to raise_error # the only one to respond to both :each_pair AND :size
    expect{subject.test=nil}.to raise_error
    expect{subject.test=""}.to raise_error
  end

  it 'allows locking selected variables' do
    class << subject
      param :test1, lockable: true
      param :test2
    end
    expect{subject.test1="1"}.not_to raise_error
    expect{subject.test2="1"}.not_to raise_error
    expect(subject.test1).to eq "1"
    expect(subject.test2).to eq "1"

    subject.lock
    expect(subject.is_locked).to eq true
    expect{subject.test1="2"}.to raise_error
    expect{subject.test2="2"}.not_to raise_error
    expect(subject.test1).to eq "1"
    expect(subject.test2).to eq "2"

    subject.lock(false)
    expect(subject.is_locked).to eq false
    expect{subject.test1="3"}.not_to raise_error
    expect{subject.test2="3"}.not_to raise_error
    expect(subject.test1).to eq "3"
    expect(subject.test2).to eq "3"
  end
  
  it 'allows restricting setting nil or empty variables' do
    class << subject
      param :test1, not_nil: true
      param :test2, not_empty: true
    end
    expect{subject.test1="1"}.not_to raise_error
    expect{subject.test2="1"}.not_to raise_error
    expect(subject.test1).to eq "1"
    expect(subject.test2).to eq "1"

    expect{subject.test1=nil}.to raise_error
    expect{subject.test2=nil}.to raise_error
    expect(subject.test1).to eq "1"
    expect(subject.test2).to eq "1"

    expect{subject.test1=""}.not_to raise_error
    expect{subject.test2=""}.to raise_error
    expect(subject.test1).to eq ""
    expect(subject.test2).to eq "1"
  end
  
  it 'allows converting to pre-defined types' do
    class << subject
      param :test_s, make_string: true
      param :test_a, make_array: true
      param :test_h, make_hash: true
      param :test_i, make_int: true
      param :test_f, make_float: true
      param :test_b, make_bool: true
    end
    expect{subject.test_s=nil}.not_to raise_error
    expect(subject.test_s).to be_a String
    expect(subject.test_s).to eq ""

    expect{subject.test_a=nil}.not_to raise_error
    expect(subject.test_a).to be_a Array
    expect(subject.test_a).to eq []
    
    expect{subject.test_h=nil}.not_to raise_error
    expect(subject.test_h).to be_a Hash
    expect(subject.test_h).to eq Hash.new
    
    expect{subject.test_i=nil}.not_to raise_error
    expect(subject.test_i).to be_a Integer
    expect(subject.test_i).to eq 0

    expect{subject.test_f=nil}.not_to raise_error
    expect(subject.test_f).to be_a Float
    expect(subject.test_f).to eq 0.0
    
    expect{subject.test_b=nil}.not_to raise_error
    expect(subject.test_b).to be_a FalseClass
    expect(subject.test_b).to eq false
  end
  
  it 'allows defining min/max boundaries for values' do
    class << subject
      param :test1, min: 10
      param :test2, max: 'c'
    end

    expect{subject.test1=11}.not_to raise_error
    expect{subject.test1=10}.not_to raise_error
    expect{subject.test1=9}.to raise_error
    
    expect{subject.test2='b'}.not_to raise_error
    expect{subject.test2='c'}.not_to raise_error
    expect{subject.test2='d'}.to raise_error
  end

  it 'allows defining ranges for values' do
    class << subject
      param :test1, in: 3..7
      param :test2, in: ['a','c']
    end

    expect{subject.test1=3}.not_to raise_error
    expect{subject.test1=6}.not_to raise_error
    expect{subject.test1=9}.to raise_error
    
    expect{subject.test2='a'}.not_to raise_error
    expect{subject.test2='c'}.not_to raise_error
    expect{subject.test2='b'}.to raise_error
  end
  
  it 'allows specifying a custom conversion method' do
    class << subject
      def check_for_x(value)
        raise "X is not allowed" if value == "x"
        "ok"
      end
      param :test1, convert: :check_for_x
      param :test2, convert: ->(value) { value+1 }
    end
    expect{subject.test1=3}.not_to raise_error
    expect(subject.test1).to eq "ok"
    expect{subject.test1="x"}.to raise_error
    
    expect{subject.test2=7}.not_to raise_error
    expect(subject.test2).to eq 8
  end
  
  it 'prints variables in to_s and inspect' do
    class << subject
      param :some_param
    end
    subject.some_param = "some value"
    expect(subject.to_s).to include "some_param='some value'"
    expect(subject.inspect).to include "some_param='some value'"
  end
end

describe Plat::Layout do
  it 'can be configured (smoke test)' do
    layout = Plat::Layout.new(env: :my_special_env) do |cfg|
      cfg.app_name = 'someAwesomeApp'
    end
    expect(layout.configuration.env).to eq 'my_special_env'
    expect(layout.configuration.app_name).to eq 'someAwesomeApp'
  end
end