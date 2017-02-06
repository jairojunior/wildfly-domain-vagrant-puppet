## Wildfly 9.0.2 Domain Vagrant Puppet

## Requirements

Working vagrant and Virtualbox. And Ruby (for r10k) 

Then:

`./setup.sh`

OR

`gem install r10k --no-ri --no-rdoc`

`r10k puppetfile install`

`vagrant up`


## Environment

Multi-machine environment with:

* load-balancer (centos-7-httpd-modcluster) (Apache + mod_cluster)
* domain-controller (centos-7-domain-controller) (Wildfly 9.0.2 Domain Controller)
* slave1 (centos-7-slave) (Wildfly 9.0.2 Host Controller)

Check: `environments/production/manifests/site.pp`

Using:

* biemond-wildfly
* puppetlabs-apache
* puppetlabs-java
* crayfishx/firewalld

## Console

http://172.28.128.20:9990

user: puppet
password: JwJEnUCS3Tc0ttcasZOjS47uy78Du4 


## mod_cluster_manager

http://172.28.128.10:6666/mod_cluster_manager

## hawt.io

http://172.28.128.10/hawtio
