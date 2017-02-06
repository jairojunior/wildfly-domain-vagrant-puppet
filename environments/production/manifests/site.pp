node 'load-balancer' {

  include role::lb

}

node 'domain-controller' {

  include role::appserver::master

}

node 'slave1' {

  include role::appserver::slave

}
