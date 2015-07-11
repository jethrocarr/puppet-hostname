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

Set the desired domain name via Hiera, and it will be appended

    hostname:domain: example.com

You can also define an array of services to reload after the hostname change
with:

    hostname:reloads:
      - rsyslog

Include the module in the usual fashion, ideally somewhere like your SOE module
so your hostname is set before the installation of most services.


# Requirements

No additional modules are required to make hostnames module work.

However, for the reloads feature to work, you must be on either Puppet 4.x or
enable the future parser in Puppet versions 3.7.5 and above, otherwise you will
see an error like this:

    Error: Syntax error at '.'; expected '}' at ... modules/hostname/manifests/init.pp:34 on node myhost

If you are using Puppet 4.x, then you don't need to do anything. If you're using
Puppet 3.7.5+, then you need to enable the future parser by either:

* Setting parser = future in your puppet.conf file
* or: Adding the command line switch --parser=future when you call Puppet.

If you're on anything older than Puppet 3.7.5, then you're out of luck.



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
