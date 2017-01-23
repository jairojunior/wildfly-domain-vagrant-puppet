# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box

    config.cache.enable :yum
    config.cache.enable :generic, 'wget' => { cache_dir: '/var/cache/wget' }
  end

  config.vm.define 'load-balancer' do |v|
    v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
    v.vm.host_name = 'load-balancer'

    v.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name = 'load-balancer'
      virtualbox.memory = 512
    end

    v.vm.network 'private_network', ip: '172.28.128.10'

  end

  config.vm.define 'domain-controller' do |v|
    v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
    v.vm.host_name = 'domain-controller'

    v.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name = 'domain-controller'
      virtualbox.memory = 1024
    end

    v.vm.network 'private_network', ip: '172.28.128.20'
  end

  config.vm.define 'slave1' do |v|
    v.vm.box = 'puppetlabs/centos-7.2-64-puppet'
    v.vm.host_name = 'slave1'

    v.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.name = 'slave1'
      virtualbox.memory = 1024
    end

    v.vm.network 'private_network', ip: '172.28.128.30'
  end

  config.vm.provision :puppet do |puppet|
    puppet.environment_path = 'environments'
    puppet.environment = 'production'
    # puppet.options = '--verbose --debug --trace --profile'
  end
end
