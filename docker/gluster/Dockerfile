FROM centos

MAINTAINER Humble Chirammal hchiramm@redhat.com
LABEL version="0.2"
LABEL description="GlusterFS container based on CentOS 7"

ENV container docker

RUN yum --setopt=tsflags=nodocs -y update; yum clean all;

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum --setopt=tsflags=nodocs -q -y install \
  wget \
  nfs-utils \
  attr \
  iputils \
  iproute \
  sudo \
  xfsprogs \
  centos-release-gluster \
  epel-release

RUN yum --setopt=tsflags=nodocs -y install \
  glusterfs \
  glusterfs-server \
  glusterfs-geo-replication \
  openssh-server

RUN yum clean all

# Configure LVM so that we can create LVs and snapshots
RUN sed -i.save -e "s#udev_sync = 1#udev_sync = 0#" \
  -e "s#udev_rules = 1#udev_rules = 0#" \
  -e "s#use_lvmetad = 1#use_lvmetad = 0#" /etc/lvm/lvm.conf

# Set password
RUN echo 'root:password' | chpasswd

# Set SSH public key
USER root
RUN mkdir -p /root/.ssh
ADD ./authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Allow commands over ssh
RUN sed -i.save -e "s#Defaults requiretty##" /etc/sudoers

VOLUME [ “/sys/fs/cgroup”, "/dev", "/run/lvm" ]

EXPOSE 22 111 245 443 24007 2049 8080 6010 6011 6012 38465 38466 38468 38469 49152 49153 49154 49156 49157 49158 49159 49160 49161 49162

RUN systemctl disable nfs-server.service
RUN systemctl enable rpcbind.service
RUN systemctl enable glusterd.service
RUN systemctl enable sshd.service

CMD ["/usr/sbin/init"]
