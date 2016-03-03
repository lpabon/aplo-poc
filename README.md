# GlusterFS + Kubernetes + Atomic + Heketi
GlusterFS containers deployed on CentOS Atomic hosts by Kubernetes with volumes allocated by Heketi. Creates a Kubernetes cluster of 4 minions, each with 500GB drives, and one master.

# Running the demo

```
$ sudo vagrant up --no-provision
$ sudo vagrant provision
$ sudo vagrant halt
<< Edit Vagrantfile and uncomment atomic.ssh.port = 8022 >>
$ sudo vagrant up
$ sudo vagrant ssh master

[vagrant@master ~]$ kubectl get nodes
[vagrant@master ~]$ kubectl create -f pods/gluster

[vagrant@master ~]$ kubectl get pods -o wide
<< wait until all pods are ready >>

[vagrant@master ~]$ export HEKETI_CLI_SERVER=http://192.168.10.103:8080
[vagrant@master ~]$ ./heketi-cli load -json=pods/topology_libvirt.json
[vagrant@master ~]$ ./heketi-cli volume create -size=200 | head

```

# Screencast
[![demo](https://i.vimeocdn.com/video/558837296_640.jpg)](https://vimeo.com/157537278)
