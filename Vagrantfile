# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'ipaddr'

load './config.rb'

def nodeIP(ips, id)
  return ((IPAddr.new ips)|(1+id)).to_s()
end

image = "sbeliakou/centos"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.synced_folder ".", "/vagrant", #disabled: true
        owner: "vagrant", 
        group: "vagrant"

    (0..$worker_count).each do |index|
        node_name = (index == 0) ? "master" : "slave-%d" % index

        config.vm.define node_name do |node|
            node.vm.box = image
            node.vm.hostname = node_name
            node.vm.network :private_network, ip: nodeIP($cluster_ips, index)
            node.vm.network "forwarded_port", guest: 80, host: 8088

            node.vm.provider :virtualbox do |vb|
                vb.name = node_name
                vb.memory = (index == 0) ? $master_memory : $worker_memory
                vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
                vb.customize ["modifyvm", :id, "--cpuexecutioncap", "#{60/($worker_count+1)}"]
            end

            node.vm.provision "shell", 
                name: "Base Installation (vagrant/scripts/base.sh)",
                path: "vagrant/scripts/base.sh",
                args: [
                    "#{($username)}"
                ]

            node.vm.provision "shell",
                name: "Master/Worker Installation (vagrant/scripts/ci-stack-#{(index == 0) ? 'master' : 'slave'}.sh)",
                path: "vagrant/scripts/ci-stack-#{(index == 0) ? 'master' : 'slave'}.sh"
           #
           # if $worker_count == 0
           #     node.vm.provision "shell",
           #         name: "Master configuration (vagrant/scripts/ci-stack-master.sh)",
           #         path: "vagrant/scripts/ci-stack-master.sh"
           # end
           #
           # if index == $worker_count
           #     node.vm.provision "shell",
           #         name: "Slave configuration (vagrant/scripts/ci-stack-slave.sh)",
           #         path: "vagrant/scripts/ci-stack-slave.sh"
           # end
        end
    end
end