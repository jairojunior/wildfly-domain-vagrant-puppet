class profile::wildfly::firewalld {
  
  firewalld::custom_service { 'Wildfly Application Server':
      short       => 'wildfly',
      description => 'Wildfly is an Application Server for Java Applications',
      port        => [
        {
            'port'     => '9990',
            'protocol' => 'tcp',
        },
        {
            'port'     => '9999',
            'protocol' => 'tcp',
        },
        {
            'port'     => '8080',
            'protocol' => 'tcp',
        },
      ],
      destination => {
        'ipv4' => '172.28.128.0/24',
      }
  }
  ->
  firewalld_service { 'Allow Wildfly from external zone':
    ensure  => 'present',
    service => 'wildfly',
    zone    => 'public',
  }
}
