Vagrant.configure(2) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box

    config.cache.enable :yum
    config.cache.enable :generic, { "wget" => { cache_dir: "/var/cache/wget" }, }
  end

  config.r10k.puppetfile_path = 'Puppetfile'
  config.r10k.puppet_dir = 'environments'
  config.r10k.module_path = 'environments/production/modules'

  config.vm.define "centos-balancer" do |v|
    v.vm.box = "puppetlabs/centos-7.0-64-puppet"
    v.vm.host_name = "centos-7-balancer-vagrant"

    v.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "centos-7-balancer-vagrant"
      virtualbox.memory = 1024
    end

    v.vm.network "private_network", ip: "172.28.128.3"

    v.vm.provision :puppet do |puppet|
      puppet.environment_path = "environments"
      puppet.environment = "production"
      # puppet.options = "--verbose --debug --trace --profile"
    end
  end

  config.vm.network "private_network", type: "dhcp"

  config.vm.define "centos-node1" do |v|
    v.vm.box = "puppetlabs/centos-7.0-64-puppet"
    v.vm.host_name = "centos-7-node1-vagrant"

    v.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "centos-7-node1-vagrant"
      virtualbox.memory = 1024
    end

    v.vm.provision :puppet do |puppet|
      puppet.environment_path = "environments"
      puppet.environment = "production"
      # puppet.options = "--verbose --debug --trace --profile"
    end
  end

  config.vm.define "centos-node2" do |v|
    v.vm.box = "puppetlabs/centos-7.0-64-puppet"
    v.vm.host_name = "centos-7-node2-vagrant"

    v.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "centos-7-node2-vagrant"
      virtualbox.memory = 1024
    end

    v.vm.provision :puppet do |puppet|
      puppet.environment_path = "environments"
      puppet.environment = "production"
      # puppet.options = "--verbose --debug --trace --profile"
    end
  end

end
