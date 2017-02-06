class profile::httpd::cluster($listen_address, $allowed_network, $manager_allowed_network, $balancer_name) {
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
    ip                      => $listen_address,
    allowed_network         => $allowed_network,
    manager_allowed_network => $manager_allowed_network,
    balancer_name           => $balancer_name,
    version                 => '1.3.1'
  }
}
