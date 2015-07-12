# Set the system hostname
class hostname (
  $hostname           = $hostname::params::hostname,
  $domain             = $hostname::params::domain,
  $reloads            = $hostname::params::reloads,
  ) inherits hostname::params {

  # Generate hostname
  if ($domain) {
    $set_fqdn = "${hostname}.${domain}"
  } else {
    # No domain provided, won't be a FQDN
    $set_fqdn = $hostname
  }

  # Write hostname to config
  file { "/etc/hostname":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "$set_fqdn\n",
    notify  => Exec["apply_hostname"],
  }

  # Set the hostname
  exec { "apply_hostname":
    command => "/bin/hostname -F /etc/hostname",
    unless  => "/usr/bin/test `hostname` = `/bin/cat /etc/hostname`",
  }

  # Make sure the hosts file has an entry
  host { 'default hostname v4':
    ensure        => present,
    name          => $set_fqdn,
    host_aliases  => $hostname,
    ip            => '127.0.0.1',
  }

# TODO: This won't work yet thanks to an ancient puppet bug:
# https://projects.puppetlabs.com/issues/8940
#  host { 'default hostname v6':
#    ensure       => present,
#    name         => $set_fqdn,
#    host_aliases => $hostname,
#    ip           => '::1',
#  }

  # Optional Reloads. We iterate over the array and then for each provided
  # service, we setup a notification relationship with the change hostname
  # command.
  #
  # Note we use a old style interation (pre future parser) to ensure
  # compatibility with Puppet 3 systems. In future when 4.x+ is standard we
  # could rewite with a newer loop approach as per:
  # https://docs.puppetlabs.com/puppet/latest/reference/lang_iteration.html

  define hostname::reloads ($service = $title) {
    Exec['apply_hostname'] ~> Service[$service]
  }

  hostname::reloads { $reloads: }

}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
