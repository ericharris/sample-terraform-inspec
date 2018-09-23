# encoding: utf-8
# copyright: 2018, The Authors

title 'webapp webserver verify'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

ENV['AWS_REGION'] = 'us-east-1'
INSTANCE_ID = params['ec2_id']['value']
SG_ID = params['sg_id']['value']

# execute test
describe aws_security_group(group_id: SG_ID) do
  it { should exist }
end

describe aws_ec2_instance(INSTANCE_ID) do
  it { should be_running }
  its('instance_type') { should eq 't2.nano' }
end
