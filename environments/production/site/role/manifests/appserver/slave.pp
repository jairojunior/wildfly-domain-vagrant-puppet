class role::appserver::slave {
  include profile::wildfly::host::controller
  include profile::wildfly::firewalld
}
