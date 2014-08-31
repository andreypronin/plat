require 'coveralls'
Coveralls.wear!

require 'dotenv'
Dotenv.load

if ENV.has_key?("STUB_AWS") || 
  !ENV.has_key?("AWS_ACCESS_KEY_ID") || 
  !ENV.has_key?("AWS_SECRET_ACCESS_KEY")
  # Test in the environment when AWS credentials are not provided
  require 'aws-sdk'
  puts "Stubbing AWS (#{ENV.has_key?("STUB_AWS") ? "forced" : "no keys"})"
  
  RSpec.configure do |c|
    c.filter_run_excluding :live_aws
  end
  
  AWS.stub! # see https://forums.aws.amazon.com/thread.jspa?threadID=114617
  #
  # Further capabilities:
  # ec2.client.stub_for(:describe_instances)[:reservation_set] = 'my-data'
  # resp = ec2.client.describe_instances
  # #=> {:reservation_set=>'my-data', :reservation_index=>{}, :instance_index=>{}}
  #
  # resp1 = ec2.client.new_stub_for(:describe_instances)
  # resp2 = ec2.client.new_stub_for(:describe_instances)
  # resp1[:called] = 1
  # resp2[:called] = 2
  # ec2.client.stub(:describe_instances).and_return(resp1, resp2)
  # ec2.describe_instances
  # #=> {:reservation_set=>[], :reservation_index=>{}, :instance_index=>{}, :call => 1}
  # ec2.describe_instances
  # #=> {:reservation_set=>[], :reservation_index=>{}, :instance_index=>{}, :call => 2}
end  

require 'plat'