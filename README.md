# Aplo
Creates a Kubernetes cluster of 4 minions, each with 500GB drives, and one master.

To bring up the cluster, type:

```
$ sudo vagrant up --no-provision
$ sudo vagrant provision
$ sudo vagrant ssh master

$ vi kube-nginx.yml
apiVersion: v1
kind: Pod
metadata:
  name: www
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 80
          hostPort: 8080

$ kubectl create -f kube-nginx.yml
$ kubectl get pod -o wide
$ curl http://<node ip>:8080
```