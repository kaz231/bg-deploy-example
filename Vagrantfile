# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/debian-8.2"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box

    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  config.vm.define "app" do |app|
    app.vm.network "private_network", ip: "192.168.55.10"
    app.ssh.forward_agent = true

    app.vm.synced_folder ".", "/vagrant"

    app.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end

    app.vm.provision "shell", path: "scripts/bootstrap_ansible.sh"
    app.vm.provision "shell", inline: "PYTHONUNBUFFERED=1 ansible-playbook /vagrant/ansible/cd.yml -c local -i /vagrant/ansible/hosts/cd"
  end
end
