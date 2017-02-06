class role::appserver::master {
  include profile::wildfly::domain::controller
  include profile::wildfly::firewalld
}
