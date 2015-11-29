node 'centos-6-balancer-vagrant' {

  firewall { '100 allow modcluster':
    chain   => 'INPUT',
    state   => ['NEW'],
    dport   => '6666',
    proto   => 'tcp',
    action  => accept
  }

  class { 'apache': }

  class { 'modcluster':
    download_url            => 'http://downloads.jboss.org/mod_cluster/1.2.6.Final/linux-x86_64/mod_cluster-1.2.6.Final-linux2-x64-so.tar.gz',
    listen_ip_address       => '*',
    allowed_network         => '172.28.128',
    balancer_name           => 'mybalancer',
    manager_allowed_network => '172.28.128',
  }

  Class['apache'] ->
    Class['modcluster'] ~>
      Service['httpd']

}

node 'centos-6-node1-vagrant' {
  include java
  include firewall_appserver
  include master

  Class['java'] ->
    Class['master']

}

node 'centos-6-node2-vagrant' {
  include java
  include firewall_appserver
  include slave

  Class['java'] ->
    Class['slave']

}

class firewall_appserver {

  firewall { '100 allow outgoing modcluster':
    chain    => 'OUTPUT',
    state    => ['NEW'],
    dport    => '6666',
    proto    => 'tcp',
    action   => accept,
  }


  firewall { '200 allow web':
    chain   => 'INPUT',
    state   => ['NEW'],
    dport   => '8080',
    proto   => 'tcp',
    action  => accept,
  }

  firewall { '300 allow management':
    chain   => 'INPUT',
    state   => ['NEW'],
    dport   => '9999',
    proto   => 'tcp',
    action  => accept,
  }

  firewall { '400 allow management':
    chain   => 'INPUT',
    state   => ['NEW'],
    dport   => '9990',
    proto   => 'tcp',
    action  => accept,
  }

}

class master {

  class { 'wildfly':
    java_home   => '/etc/alternatives/java_sdk',
    mode        => 'domain',
    host_config => 'host-master.xml'
  }

  wildfly::config::mgmt_user { 'Slave1 server user':
    username => 'slave1',
    password => 'wildfly',
  }


}

class slave {

  class { 'wildfly':
    java_home   => '/etc/alternatives/java_sdk',
    mode        => 'domain',
    host_config => 'host-slave.xml',
    domain_slave => {
      host_name => 'slave1',
      secret    => 'd2lsZGZseQ==',
      domain_master_address => '172.28.128.3',
    }
  }

}