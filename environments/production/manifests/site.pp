node 'centos-7-load-balancer' {

  #  Download modcluster http://downloads.jboss.org/mod_cluster//1.3.1.Final/linux-x86_64/mod_cluster-1.3.1.Final-linux2-x64.tar.gz
  # include apache::mod::cluster

}

node 'centos-7-domain-controller' {
  include java
  include firewalld_appserver
  include master

  Class['java'] ->
    Class['master']

}

node 'centos-7-slave1' {
  include java
  include firewalld_appserver
  include slave

  Class['java'] ->
    Class['slave']

}

class firewalld_appserver {

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
