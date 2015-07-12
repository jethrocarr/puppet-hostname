class hostname::params () {
  # Define the hostnamr (without domain) to be used.
  $hostname = $::hostname

  # Define the domain to be used
  $domain = undef

  # Array of Puppet service names to be reloaded after hostname change.
  # Generally you will need to at least restart syslog (or variant).
  $reloads = []
}

# vi:smartindent:tabstop=2:shiftwidth=2:expandtab:
