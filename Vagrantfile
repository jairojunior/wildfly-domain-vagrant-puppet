# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'puppetlabs/centos-7.2-64-nocm'

  config.vm.define 'load-balancer' do |v|
    v.vm.host_name = 'load-balancer'
    v.vm.network 'private_network', ip: '172.28.128.10'
  end

  config.vm.define 'domain-controller' do |v|
    v.vm.host_name = 'domain-controller'
    v.vm.network 'private_network', ip: '172.28.128.20'
  end

  config.vm.define 'slave1' do |v|
    v.vm.host_name = 'slave1'
    v.vm.network 'private_network', ip: '172.28.128.30'
  end

  bootstrap_script = <<-EOF
    if which puppet > /dev/null 2>&1; then
      echo 'Puppet Installed.'
    else
      yum install -y http://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install puppet-agent -y
    fi
  EOF

  config.vm.provision :shell, inline: bootstrap_script

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = 'environments'
    puppet.environment = 'production'
    puppet.hiera_config_path = 'hiera.yaml'
    # puppet.options = '--verbose --debug --trace --profile'
  end
end
