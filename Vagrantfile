# -*- mode: ruby -*-
# vi: set ft=ruby :

NODES = 4
DISKS = 8

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.box = "centos/atomic-host"

    # Override
    config.vm.provider :libvirt do |v,override|
        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end

    # Make non-storage machine
    config.vm.define :client do |client|
        client.vm.network :private_network, ip: "192.168.10.90"
        client.vm.host_name = "client"
        client.vm.provider :virtualbox do |vb|
            vb.memory = 1024
            vb.cpus = 2
        end

        client.vm.provider :libvirt do |lv|
            lv.memory = 1024
            lv.cpus = 2
        end

    end

    # Make the glusterfs cluster, each with DISKS number of drives
    (0..NODES-1).each do |i|
        config.vm.define "atomic#{i}" do |atomic|
            atomic.vm.hostname = "atomic#{i}"
            atomic.vm.network :private_network, ip: "192.168.10.10#{i}"
            (0..DISKS-1).each do |d|
                atomic.vm.provider :virtualbox do |vb|
                    vb.customize [ "createhd", "--filename", "disk-#{i}-#{d}.vdi", "--size", 500*1024 ]
                    vb.customize [ "storageattach", :id, "--storagectl", "SATA Controller", "--port", 3+d, "--device", 0, "--type", "hdd", "--medium", "disk-#{i}-#{d}.vdi" ]
                    vb.memory = 1024
                    vb.cpus = 2
                end
                driverletters = ('b'..'z').to_a
                atomic.vm.provider :libvirt do  |lv|
                    lv.storage :file, :device => "vd#{driverletters[d]}", :path => "disk-#{i}-#{d}.disk", :size => '500G'
                    lv.memory = 1024
                    lv.cpus =2
                end
            end

            #if i == (NODES-1)
            if false
                # View the documentation for the provider you're using for more
                # information on available options.
                atomic.vm.provision :ansible do |ansible|
                    ansible.limit = "all"
                    ansible.playbook = "site.yml"
                    ansible.groups = {
                        "client" => ["client"],
                        "heketi" => ["atomic0"],
                        "gluster" => (0..NODES-1).map {|j| "atomic#{j}"},
                    }

                end
            end
        end
    end
end
