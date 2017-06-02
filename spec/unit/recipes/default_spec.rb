#
# Cookbook:: consul-docker
# Spec:: default
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


require 'spec_helper'

describe 'consul-docker::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    cached(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'pulls consul image' do
      expect(chef_run).to pull_docker_image('consul').with(repo: 'consul', tag: '0.8.3')
    end

    it 'starts consul container' do
      expect(chef_run).to run_docker_container('consul')
        .with(command: 'agent', env: [], repo: 'consul', tag: '0.8.3',
              port: ['8300', '8301', '8302', '8500', '8600'],
              sensitive: false)
    end
  end

  context 'When attributes are overridden, on an Ubuntu 16.04' do
    cached(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node, server|
        node.normal['consul-docker']['config']['consul_local_config']['bootstrap-expect'] = 2
        node.normal['consul-docker']['config']['consul_local_config']['server'] = true
        node.normal['consul-docker']['config']['consul_local_config']['retry-join'] = ['192.168.1.3', '192.168.1.2']
        node.normal['consul-docker']['config']['consul_http_addr'] = '0.0.0.0'
        node.normal['consul-docker']['repo'] = 'jmccann/consul'
        node.normal['consul-docker']['port'] = ['1', '2']
        node.normal['consul-docker']['sensitive'] = true
        node.normal['consul-docker']['vault']['bag'] = 'vault_consul'
        node.normal['consul-docker']['vault']['items'] = ['acl_master_token']
        node.normal['consul-docker']['tag'] = 'rc'

        inject_databags server
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'pulls consul image' do
      expect(chef_run).to pull_docker_image('consul').with(repo: 'jmccann/consul', tag: 'rc')
    end

    it 'starts consul container' do
      expect(chef_run).to run_docker_container('consul')
        .with(command: 'agent', repo: 'jmccann/consul', tag: 'rc',
              port: ['1', '2'], sensitive: true)
    end

    describe 'consul container environment' do
      let(:consul_env) do
        chef_run.docker_container('consul').env
      end

      it 'creates consul json config' do
        expect(consul_env).to include('CONSUL_LOCAL_CONFIG={"bootstrap-expect":2,"server":true,"retry-join":["192.168.1.3","192.168.1.2"],"acl_master_token":"8fa14cdd754f91cc6554c9e71929cce7"}')
      end

      it 'sets http addr to listen on' do
        expect(consul_env).to include('CONSUL_HTTP_ADDR=0.0.0.0')
      end
    end
  end
end
