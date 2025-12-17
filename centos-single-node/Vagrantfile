# -*- mode: ruby -*-
# vi: set ft=ruby :

# Устанавливаем провайдер по умолчанию на vmware_desktop
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_desktop'

if ENV['VAGRANT_NODE_DISTR']
  VAGRANT_NODE_DISTR = ENV['VAGRANT_NODE_DISTR']
else
  # "generic/centos9s" — отличный выбор, так как он поддерживает и vbox, и vmware
  VAGRANT_NODE_DISTR = "generic/centos9s"
end

Vagrant.configure("2") do |config|
  config.vm.define "node1" do |node|
    # Отключаем vbguest, так как он не нужен для VMware (используются open-vm-tools)
    if Vagrant.has_plugin?("vagrant-vbguest")
      node.vbguest.auto_update = false
    end

    node.vm.box = "#{VAGRANT_NODE_DISTR}"
    node.vm.hostname = "node1.example.com"

    # В VMware настройка частной сети (Host-only) проще:
    node.vm.network "private_network", ip: "192.0.2.101"

    node.vm.provision "node", type: "shell", path: "./provision-node.sh"

    # Настройки для VMware
    node.vm.provider "vmware_desktop" do |v|
      v.gui = false
      v.memory = 1024
      v.cpus = 1
      # Аналог оптимизации для производительности
      v.vmx["memsize"] = "1024"
      v.vmx["numvcpus"] = "1"
    end
  end
end
