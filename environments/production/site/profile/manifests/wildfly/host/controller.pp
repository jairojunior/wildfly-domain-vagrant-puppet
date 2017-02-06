class profile::wildfly::host::controller($domain_bind_address, $bind_address) {

  class { 'profile::wildfly::domain': 
    config     => 'host-slave.xml',
    properties  => {
      'jboss.domain.master.address' => $domain_bind_address,
      'jboss.bind.address'          => $bind_address,
    },
    secret_value => 'd2lsZGZseQ==', #base64('wildfly')
  }

  firewalld_port { 'Open port 8159 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 8159,
    protocol => 'tcp',
  }
}
