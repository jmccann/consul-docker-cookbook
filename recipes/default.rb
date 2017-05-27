#
# Cookbook:: consul-docker
# Recipe:: default
#
# Copyright:: 2017, Jacob McCann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cookbook_file '/root/entrypoint.sh'

docker_image 'consul' do
  repo node['consul']['repo']
  tag node['consul']['tag']
end

docker_container 'consul' do
  command 'agent'
  entrypoint node['consul']['entrypoint'] if node['consul']['entrypoint']
  env docker_env(node['consul']['config']) if node['consul']['config']
  port node['consul']['port']
  repo node['consul']['repo']
  restart_policy 'always'
  tag node['consul']['tag']
  network_mode 'host'
  sensitive node['consul']['sensitive']
  volumes node['consul']['volumes'] if node['consul']['volumes']
end
