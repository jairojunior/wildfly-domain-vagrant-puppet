class profile::wildfly::domain($config, $properties, $secret_value = undef) {

  include java

  class { 'wildfly':
    java_home    => '/etc/alternatives/java_sdk',
    mode         => 'domain',
    host_config  => $config,
    properties   => $properties,
    secret_value => $secret_value,
  }

  Class['java'] ->
    Class['wildfly']

}
