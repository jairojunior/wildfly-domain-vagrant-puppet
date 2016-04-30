node 'centos-7-load-balancer' {

  #  Download modcluster http://downloads.jboss.org/mod_cluster//1.3.1.Final/linux-x86_64/mod_cluster-1.3.1.Final-linux2-x64.tar.gz
  # include apache::mod::cluster

}

node 'centos-7-domain-controller' {

  include java
  include master
  include firewalld_appserver

  Class['java'] ->
    Class['master'] ->
      Class['firewalld_appserver']

}

node 'centos-7-slave1' {

  include java
  include slave
  include firewalld_appserver

  Class['java'] ->
    Class['slave'] ->
      Class['firewalld_appserver']

}

class firewalld_appserver {

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
            'protocol' => 'udp',
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

class master {

  class { 'wildfly':
    version                => '8.2.1',
    install_source         => 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz',
    java_home              => '/etc/alternatives/java_sdk',
    mode                   => 'domain',
    domain_controller_only => true,
    host_config            => 'host-master.xml'
  }

  wildfly::config::mgmt_user { 'slave1':
    password => 'wildfly',
  }

  wildfly::deployment { 'hawtio.war':
    source       => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.64/hawtio-web-1.4.64.war',
    server_group => 'main-server-group',
  }


}

class slave {

  class { 'wildfly':
    version        => '8.2.1',
    install_source => 'http://download.jboss.org/wildfly/8.2.1.Final/wildfly-8.2.1.Final.tar.gz',
    java_home      => '/etc/alternatives/java_sdk',
    mode           => 'domain',
    host_config    => 'host-slave.xml',
    domain_slave   => {
      host_name             => 'slave1',
      secret                => 'd2lsZGZseQ==',
      domain_master_address => '172.28.128.20',
    }
  }

}
