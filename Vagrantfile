# -*- mode: ruby -*-
# vi: set ft=ruby :

MINIONS = 4
DISKS = 8

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.box = "centos/atomic-host"

    # Override
    config.vm.provider :libvirt do |v,override|
        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end
    config.vm.provider :virtualbox do |v,override|
        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end

    # Make kub master
    config.vm.define :master do |master|
        master.vm.network :private_network, ip: "192.168.10.90"
        master.vm.host_name = "master"
        master.vm.provider :virtualbox do |vb|
            vb.memory = 1024
            vb.cpus = 2
        end

        master.vm.provider :libvirt do |lv|
            lv.memory = 1024
            lv.cpus = 2
        end

    end

    # Make the glusterfs cluster, each with DISKS number of drives
    (0..MINIONS-1).each do |i|
        config.vm.define "atomic#{i}" do |atomic|
            atomic.vm.hostname = "atomic#{i}"
            atomic.vm.network :private_network, ip: "192.168.10.10#{i}"
            #
            atomic.ssh.port = 8022
            #
            atomic.vm.provider :virtualbox do |vb|
                vb.customize ["storagectl", :id,"--name", "SATAController", "--add", "sata"]
            end

            (0..DISKS-1).each do |d|
                atomic.vm.provider :virtualbox do |vb|
                    unless File.exist?("disk-#{i}-#{d}.vdi")
                        vb.customize [ "createmedium", "--filename", "disk-#{i}-#{d}.vdi", "--size", 500*1024 ]
                    end
                    vb.customize [ "storageattach", :id, "--storagectl", "SATAController", "--port", 3+d, "--device", 0, "--type", "hdd", "--medium", "disk-#{i}-#{d}.vdi" ]
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

            if i == (MINIONS-1)
                # View the documentation for the provider you're using for more
                # information on available options.
                atomic.vm.provision :ansible do |ansible|

                    if ARGV[1] and \
                       (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
                      provider = (ARGV[1].split('=')[1] || ARGV[2])
                    else
                      provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
                    end
                    puts "Detected #{provider}"

                    ansible.extra_vars = {provider: "#{provider}"}
                    ansible.limit = "all"
                    ansible.playbook = "site.yml"
                    ansible.groups = {
                        "master" => ["master"],
                        "minions" => (0..MINIONS-1).map {|j| "atomic#{j}"},
                    }
                end
            end
        end
    end
end
