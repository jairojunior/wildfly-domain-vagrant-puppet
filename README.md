## Wildfly HA Vagrant Puppet

## Requirements

Working vagrant and virtualbox.

Then:

`vagrant plugin install vagrant-librarian-puppet`

`mkdir puppet/modules`

`vagrant up`

And you should have an environemnt as described in the next section.

## Environment

Multi-machine environment with:

* Load Balancer (centos-6-balancer-vagrant) (Apache + modcluster)
* Node 1 (centos-6-node1-vagrant) (Wildfly 8.2.0 standalone-ha)
* Node 2 (centos-6-node2-vagrant) (Wildfly 8.2.0 standalone-ha)

Using:

* https://github.com/jairojunior/biemond-wildfly (forked from https://github.com/biemond/biemond-wildfly)
* https://github.com/jairojunior/puppet-modcluster
* https://github.com/jairojunior/wildfly-cli-wrapper

## mod_cluster_manager

Access mod_cluster_manager at http://172.28.128.3:6666/mod_cluster_manager