# puppet-hostname

Most cloud providers will generate a unique machine ID or name based on the
parameters provided at launch time. On AWS, this will generally be "i-xyz123"
on other providers like Digital Ocean it will be the human-assigned instance
name eg "host1".

What they fail to do, is to set the FQDN of the server to anything useful. And
sure, you could set it via your own Puppet code chucked into SOE, or you could
add it as more bloat to your user data, but let's do something properly for
once and have a nice tidy module for it. :-)


# Features

* Sets the FDQN hostname on a server.
* Reload services that get impacted by hostname changes.
* Planned: Also set DNS names on services like Route53.


# Usage

Set the desired domain name via Hiera, and it will be appended:

    hostname::domain: example.com

You can also define an array of services to reload after the hostname change:
(just remember that the services must be defined in Puppet first)

    hostname::reloads:
      - rsyslog

If you wish to override the default system hostname entirely, you can set both
the hostname and the domain, eg:

    hostname::hostname: host1
    hostname::domain: example.com


Include the module in the usual fashion, ideally somewhere like your SOE module
so your hostname is set before the installation of most services.


# Requirements

No additional modules are required to make hostnames module work.


# Development

Contributions via the form of Pull Requests always welcome. Ideas for PRs
include:

1. Setting of DNS on popular providers.
2. Generate of machine IDs in new and creative ways.
3. Finding the machine ID via reverse DNS?


# License

This module is licensed under the Apache License, Version 2.0 (the "License").
See the `LICENSE` or http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
