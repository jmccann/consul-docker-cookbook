# consul-docker

Cookbook to setup consul using docker.

## Supported Platforms

Tested And Validated On
- Ubuntu 16.04

## Usage

### Recipe: consul-docker::default

Include `consul-docker` in your run_list.

```json
{
  "run_list": [
    "recipe[consul-docker::default]"
  ]
}
```

### Attributes

Attribute | Description | Type | Default
----------|-------------|------|--------
`node['consul-docker']['config']` | Hash of configuration environment variables for Consul.  Primary way to configure how consul starts. See [consul docker image](https://hub.docker.com/_/consul/) and [consul configuration file docs](https://www.consul.io/docs/agent/options.html#configuration-files) for more information.  See [`.kitchen.yml`](.kitchen.yml) for examples of using this to drive behavior. | Hash | `nil`
`node['consul-docker']['entrypoint']` | Start the consul container with your own entrypoint.  Must be added as volume to container. | String | `nil`
`node['consul-docker']['port']` | Port(s) to expose from docker container. See [docker cookbook](https://github.com/chef-cookbooks/docker#properties-7) for more info. | Array | `['8300', '8301', '8302', '8400', '8500', '8600']`
`node['consul-docker']['repo']` | The docker repo for the image to use | String | `'consul'`
`node['consul-docker']['tag']` | The docker tag for the image to use | String | `'0.8.3'`
`node['consul-docker']['sensitive']` | Whether to consider container resource sensitive or not | Boolean | `false`
`node['consul-docker']['vault']['bag']` | Vault bag to use for secrets | String | `nil`
`node['consul-docker']['vault']['items']` | Vault items to load into config | Array | `nil`
`node['consul-docker']['volumes']` | Volumes to have added to your container | Array | `nil`

### ACL Configuration

The [`.kitchen.yml`](.kitchen.yml) has an example of setting up ACLs.  More info
can be found at the [ACL System Docs](https://www.consul.io/docs/guides/acl.html).

Currently this can't be totally automated to work with default `deny` policy.
This is documented at https://github.com/hashicorp/consul/issues/3054 and
manual steps required at https://gist.github.com/slackpad/d89ce0e1cc0802c3c4f2d84932fa3234.

### TLS Configuration

The [`.kitchen.yml`](.kitchen.yml) has an example of setting up TLS for encyption.
More info cab be found at the [Encryption Docs](https://www.consul.io/docs/agent/encryption.html).

## Testing

* Linting - Cookstyle and Foodcritic
* Spec - ChefSpec
* Integration - Test Kitchen

Testing requires [ChefDK](https://downloads.chef.io/chef-dk/) be installed using it's native gems.

```
foodcritic -f any -X spec .
cookstyle
rspec --color --format progress
```

If you run into issues testing please first remove any additional gems you may
have installed into your ChefDK environment.  Extra gems can be found and removed
at `~/.chefdk/gem`.

## License and Authors

Author:: Jacob McCann (<jacob.mccann2@target.com>)

```text
Copyright:: 2017, Jacob McCann

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

```
