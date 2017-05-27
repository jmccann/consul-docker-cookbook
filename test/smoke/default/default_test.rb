# # encoding: utf-8

# Inspec test for recipe consul-docker::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

puts "Sleeping for 20 seconds while consul cluster forms"
sleep 20

# Make sure all ports are up
describe port(8300) do
  it { should be_listening }
end
describe port(8301) do
  it { should be_listening }
end
describe port(8302) do
  it { should be_listening }
end
describe port(8500) do
  it { should be_listening }
end
describe port(8600) do
  it { should be_listening }
end

# Make sure cluster joined OK
describe command('docker logs consul') do
  its('stdout') { should include('(LAN) joined: 1 Err: <nil>') }
end

# Make sure can register service
# describe command('curl -f --request PUT --header "X-Consul-Token: 8fa14cdd754f91cc6554c9e71929cce7" --data @/root/payload.json http://localhost:8500/v1/catalog/register') do
#   its('exit_status') { should eq 0 }
# end
describe command('curl -k -f --request PUT --data @/root/payload.json https://localhost:9000/v1/catalog/register') do
  its('exit_status') { should eq 0 }
end

# Make sure can DNS service
describe command('dig @127.0.0.1 -p 8600 redis.service.consul') do
  its('stdout') { should include('ANSWER SECTION') }
  its('stdout') { should include('192.168.30.10') }
end
