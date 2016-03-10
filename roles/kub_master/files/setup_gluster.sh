#!/bin/bash
kubectl exec gluster-1 -- gluster volume info
kubectl exec glutser-1 -- gluster peer probe 192.168.10.101
kubectl exec glutser-1 -- gluster peer probe 192.168.10.102
kubectl exec glutser-1 -- gluster volume create glustervol replica 3 192.168.10.100:/srv/brick/brick1 192.168.10.101:/srv/brick/brick1 192.168.10.102:/srv/brick/brick1
kubectl exec glutser-1 -- gluster volume start glustervol

