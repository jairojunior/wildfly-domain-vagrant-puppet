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

node /^centos-6-node\d+-vagrant$/ {
  include app
}

class app {

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
    dport   => '9990',
    proto   => 'tcp',
    action  => accept,
  }

  class { 'jdk_oracle':
    version => 8
  }

  class { 'wildfly':
    java_home => '/opt/jdk-8',
    config    => 'standalone-ha.xml'
  }

  Class['jdk_oracle'] ->
    Class['wildfly'] ->
      wildfly::standalone::modcluster::config { "Modcluster mybalancer":
        balancer => 'mybalancer',
        load_balancing_group => 'demolb',
        proxy_url => '/',
        proxy_list => '172.28.128.3:6666'
      }

}

#
# Extracted from https://github.com/biemond/vagrant-fedora20-puppet/blob/master/puppet/modules/jdk_oracle/manifests/init.pp
#
class jdk_oracle(
  $version      = hiera('jdk_oracle::version',     '7' ),
  $install_dir  = hiera('jdk_oracle::install_dir', '/opt' ),
  $use_cache    = hiera('jdk_oracle::use_cache',   false ),
  $platform     = hiera('jdk_oracle::platform',   'x64' ),
) {

# Set default exec path for this module
  Exec { path    => ['/usr/bin', '/usr/sbin', '/bin'] }

  case $platform {
    'x64': {
      $plat_filename = 'x64'
    }
    'x86': {
      $plat_filename = 'i586'
    }
    default: {
      fail("Unsupported platform: ${platform}.  Implement me?")
    }
  }
  case $version {
    '8': {
      $javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-linux-${plat_filename}.tar.gz"
      $java_home = "${install_dir}/jdk1.8.0_20"
    }
    '7': {
      $javaDownloadURI = "http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-${plat_filename}.tar.gz"
      $java_home = "${install_dir}/jdk1.7.0"
    }
    '6': {
      $javaDownloadURI = "https://edelivery.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-${plat_filename}.bin"
      $java_home = "${install_dir}/jdk1.6.0_45"
    }
    default: {
      fail("Unsupported version: ${version}.  Implement me?")
    }
  }

  $installerFilename = inline_template('<%= File.basename(@javaDownloadURI) %>')

  if ( $use_cache ){
    notify { 'Using local cache for oracle java': }
    file { "${install_dir}/${installerFilename}":
      source  => "puppet:///modules/jdk_oracle/${installerFilename}",
    }
    exec { 'get_jdk_installer':
      cwd     => $install_dir,
      creates => "${install_dir}/jdk_from_cache",
      command => 'touch jdk_from_cache',
      require => File["${install_dir}/jdk-${version}-linux-x64.tar.gz"],
    }
  } else {
    exec { 'get_jdk_installer':
      cwd     => $install_dir,
      creates => "${install_dir}/${installerFilename}",
      command => "wget -c --no-cookies --no-check-certificate --header \"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com\" --header \"Cookie: oraclelicense=accept-securebackup-cookie\" \"${javaDownloadURI}\" -O ${installerFilename}",
      timeout => 600,
      require => Package['wget'],
    }
    file { "${install_dir}/${installerFilename}":
      mode    => '0755',
      require => Exec['get_jdk_installer'],
    }
  }

# Java 7/8 comes in a tarball so just extract it.
  if ( $version in [ '7', '8' ] ) {
    exec { 'extract_jdk':
      cwd     => "${install_dir}/",
      command => "tar -xf ${installerFilename}",
      creates => $java_home,
      require => Exec['get_jdk_installer'],
    }
  }
# Java 6 comes as a self-extracting binary
  if ( $version == '6' ) {
    exec { 'extract_jdk':
      cwd     => "${install_dir}/",
      command => "${install_dir}/${installerFilename}",
      creates => $java_home,
      require => File["${install_dir}/${installerFilename}"],
    }
  }

# Set links depending on osfamily or operating system fact
  case $::osfamily {
    RedHat, Linux: {
      file { '/etc/alternatives/java':
        ensure  => link,
        target  => "${java_home}/bin/java",
        require => Exec['extract_jdk'],
      }
      file { '/etc/alternatives/javac':
        ensure  => link,
        target  => "${java_home}/bin/javac",
        require => Exec['extract_jdk'],
      }
      file { '/usr/sbin/java':
        ensure  => link,
        target  => '/etc/alternatives/java',
        require => File['/etc/alternatives/java'],
      }
      file { '/usr/sbin/javac':
        ensure  => link,
        target  => '/etc/alternatives/javac',
        require => File['/etc/alternatives/javac'],
      }
      file { "${install_dir}/java_home":
        ensure  => link,
        target  => $java_home,
        require => Exec['extract_jdk'],
      }
      file { "${install_dir}/jdk-${version}":
        ensure  => link,
        target  => $java_home,
        require => Exec['extract_jdk'],
      }
    }
    Debian:    { fail('TODO: Implement me!') }
    Suse:      { fail('TODO: Implement me!') }
    Solaris:   { fail('TODO: Implement me!') }
    Gentoo:    { fail('TODO: Implement me!') }
    Archlinux: { fail('TODO: Implement me!') }
    Mandrake:  { fail('TODO: Implement me!') }
    default:     { fail('Unsupported OS') }
  }

}