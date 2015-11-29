## Wildfly HA Vagrant Puppet

## Requirements

Working vagrant and Virtualbox.

Then:

`vagrant plugin install vagrant-r10k`

`mkdir environments/production/modules`

`vagrant up`

And you'll an environemnt as described in the next section.

## Environment

Multi-machine environment with:

* Load Balancer (centos-6-balancer-vagrant) (Apache + modcluster)
* Node 1 (centos-6-node1-vagrant) (Wildfly 8.2.1 Domain Controller)
* Node 2 (centos-6-node2-vagrant) (Wildfly 8.2.0 Slave)

Using:

* https://github.com/biemond/biemond-wildfly
* https://github.com/jairojunior/puppet-modcluster

## mod_cluster_manager

Access mod_cluster_manager at http://172.28.128.3:6666/mod_cluster_manager