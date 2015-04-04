Vagrant.configure(2) do |config|

  config.librarian_puppet.puppetfile_dir = "puppet"
  config.vm.network "private_network", type: "dhcp"

  config.vm.define "centos-balancer" do |v|
    v.vm.box = "puppetlabs/centos-6.6-64-puppet"
    v.vm.host_name = "centos-6-balancer-vagrant"

    v.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "centos-6-balancer-vagrant"
      virtualbox.memory = 1024
    end

    v.vm.provision :puppet, :options => ["--pluginsync"] do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "site.pp"
      puppet.options = "--environment dev --verbose --debug --trace"
    end
  end

  config.vm.define "centos-node1" do |v|
    v.vm.box = "puppetlabs/centos-6.6-64-puppet"
    v.vm.host_name = "centos-6-node1-vagrant"

    v.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "centos-6-node1-vagrant"
      virtualbox.memory = 1024
    end

    v.vm.provision :puppet, :options => ["--pluginsync"] do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "site.pp"
      puppet.options = "--environment dev --verbose --debug --trace"
    end
  end

  config.vm.define "centos-node2" do |v|
    v.vm.box = "puppetlabs/centos-6.6-64-puppet"
    v.vm.host_name = "centos-6-node2-vagrant"

    v.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "centos-6-node2-vagrant"
      virtualbox.memory = 1024
    end

    v.vm.provision :puppet, :options => ["--pluginsync"] do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet"
      puppet.manifest_file = "site.pp"
      puppet.options = "--environment dev --verbose --debug --trace"
    end
  end

end
