class profile::wildfly::domain::controller($bind_address, $proxies) {

  class { 'profile::wildfly::domain':
    config     => 'host-master.xml',
    properties => {
      'jboss.bind.address.management' => $bind_address,
    },
  }

  wildfly::config::mgmt_user { 'slave1':
    password => 'wildfly',
  }

  wildfly::deployment { 'hawtio.war':
    source       => 'http://central.maven.org/maven2/io/hawt/hawtio-web/1.4.68/hawtio-web-1.4.68.war',
    server_group => 'other-server-group',
  }

  $proxies.each |$index, $proxy| {
    $host_port = split($proxy, ':')

    wildfly::resource { "/socket-binding-group=full-ha-sockets/remote-destination-outbound-socket-binding=proxy${index}":
      content => {
        'host' => $host_port[0],
        'port' => $host_port[1],
      },
      before  => Wildfly::Modcluster::Config['mycluster']
    }
  }

  $number_of_proxies = count($proxies) - 1

  wildfly::modcluster::config { 'mycluster':
    balancer             => 'mycluster',
    load_balancing_group => 'demolb',
    proxy_url            => '/',
    proxies              => range('proxy0',"proxy${number_of_proxies}"),
    target_profile       => 'full-ha',
  }
}
