node 'load-balancer' {

  $modules_dir = '/etc/httpd/modules'

  class { '::apache':
    default_vhost => true,
  }


  archive { '/tmp/mod_cluster-1.3.1.Final-linux2-x64.tar.gz':
    ensure       => present,
    extract      => true,
    extract_path => $modules_dir,
    source       => 'http://downloads.jboss.org/mod_cluster//1.3.1.Final/linux-x86_64/mod_cluster-1.3.1.Final-linux2-x64-so.tar.gz',
    creates      => ["${modules_dir}/mod_advertise.so",
                      "${modules_dir}/mod_cluster_slotmem.so",
                        "${modules_dir}/mod_manager.so",
                          "${modules_dir}/mod_proxy_cluster.so"],
    cleanup      => true,
  }
  ->
  class { '::apache::mod::cluster':
    ip                      => '172.28.128.10',
    allowed_network         => '172.28.128.',
    manager_allowed_network => '172.28.128.',
    balancer_name           => 'mycluster',
    version                 => '1.3.1'
  }
  ->
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

node 'domain-controller' {

  include java
  include master
  include firewalld_appserver

  Class['java'] ->
    Class['master'] ->
      Class['firewalld_appserver']

}

node 'slave1' {

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

class master {

  class { 'wildfly':
    java_home   => '/etc/alternatives/java_sdk',
    mode        => 'domain',
    host_config => 'host-master.xml',
    properties  => {
      'jboss.bind.address.management' => '172.28.128.20',
    },
  }

  wildfly::config::mgmt_user { 'slave1':
    password => 'wildfly',
  }

  wildfly::deployment { 'hawtio.war':
    source       => 'https://oss.sonatype.org/content/repositories/public/io/hawt/hawtio-default-offline/1.4.68/hawtio-default-offline-1.4.68.war',
    server_group => 'main-server-group',
  }

  wildfly::modcluster::config { 'Modcluster mybalancer':
    balancer             => 'mycluster',
    load_balancing_group => 'demolb',
    proxy_url            => '/',
    proxy_list           => '172.28.128.10:6666',
    target_profile       => 'full-ha',
  }

  firewalld_port { 'Open port 8159 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 8159,
    protocol => 'tcp',
  }

}

class slave {

  class { 'wildfly':
    java_home    => '/etc/alternatives/java_sdk',
    mode         => 'domain',
    host_config  => 'host-slave.xml',
    properties   => {
      'jboss.domain.master.address' => '172.28.128.20',
    },
    secret_value => 'd2lsZGZseQ==', #base64('wildfly'),
  }

}
