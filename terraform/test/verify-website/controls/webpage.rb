# encoding: utf-8
# copyright: 2018, The Authors

title 'webapp webpage verify'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

INSTANCE_URL = params['ec2_url']['value']

# execute test
describe http(INSTANCE_URL) do
  its('status') { should eq 200 }
  its('body') { should match 'I know what you did last expense report' }
end