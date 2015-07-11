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
    notify => Exec["set-hostname"],
  }

  # Set the hostname
  exec { "apply_hostname":
    command => "/bin/hostname -F /etc/hostname",
    unless  => "/usr/bin/test `hostname` = `/bin/cat /etc/hostname`",
  }

  # Optional Reloads. We iterate over the array and then for each provided
  # service, we setup a notification relationship with the change hostname
  # command.
  if ($reloads) {
    $reloads.each |String $service| {
      Exec['apply_hostname'] ~> Service[$service]
    }
  }
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
