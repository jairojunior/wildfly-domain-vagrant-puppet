class profile::httpd::cluster::firewalld {

  firewalld::custom_service { 'httpd with mod_cluster':
      short       => 'httpd',
      description => 'httpd with mod_cluster',
      port        => [
        {
            'port'     => '6666',
            'protocol' => 'tcp',
        },
        {
            'port'     => '80',
            'protocol' => 'tcp',
        },
      ],
      destination => {
        'ipv4' => '172.28.128.0/24',
      }
  }
  ->
  firewalld_service { 'Allow httpd from external zone':
    ensure  => 'present',
    service => 'httpd',
    zone    => 'public',
  }

}
