# Set the system hostname
class hostname (
  $domain             = $hostname::params::domain,
  $reloads            = $hostname::params::reloads,
  ) inherits hostname::params {

  # Generate hostname
  if ($domain) {
    $set_hostname = "${::hostname}.${domain}"
  } else {
    # No FDQN provided, leave hostname as-is.
    $set_hostname = $::hostname
  }

  # Write hostname to config
  file { "/etc/hostname":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "$set_hostname\n",
    notify => Exec["apply_hostname"],
  }

  # Set the hostname
  exec { "apply_hostname":
    command => "/bin/hostname -F /etc/hostname",
    unless  => "/usr/bin/test `hostname` = `/bin/cat /etc/hostname`",
  }

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
