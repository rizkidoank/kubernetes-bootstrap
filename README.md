# kubernetes-bootstrap

## Architecture
Didn't have time to do it.

## Cluster Specifications
- Image: k8s-1.21.4 built on top of ubuntu cloud focal
- Virtualization: Libvirt KVM
- Provisioner: Terraform (using libvirt), kubeadm
- Control plane: single
- Worker nodes: 3 nodes

### libvirt domains
```
➜  kubernetes-bootstrap git:(main) ✗ sudo virsh list
 Id   Name                               State
--------------------------------------------------
 1    playground.rizkidoank.internal     running
 2    rdlab-k8s-04.rizkidoank.internal   running
 3    rdlab-k8s-01.rizkidoank.internal   running
 4    rdlab-k8s-03.rizkidoank.internal   running
 5    rdlab-k8s-02.rizkidoank.internal   running
 ```

### kubectl get nodes
```
NAME           STATUS   ROLES                  AGE   VERSION
rdlab-k8s-01   Ready    control-plane,master   21h   v1.21.4
rdlab-k8s-02   Ready    <none>                 21h   v1.21.4
rdlab-k8s-03   Ready    <none>                 21h   v1.21.4
rdlab-k8s-04   Ready    <none>                 21h   v1.21.4
```

## Services
- ArgoCD: argocd.rizkidoank.com (limited access)
- Grafana: grafana.rizkidoank.com (public, with auth)
- Longhorn: private-only, for persistent volume
- Traefik: private-only, ingress controller
- Metallb: private-only, load-balancer

Additional:
- Cloudflared tunnel to expose to public

### Redis PV
```
➜  ~ kubectl get pvc
NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
redis-data-redis-master-0     Bound    pvc-c8ee4229-e5e5-47f7-9f6a-e9043c536f69   8Gi        RWO            longhorn       11m
redis-data-redis-replicas-0   Bound    pvc-57463065-7d63-4999-a161-1bcccbb891f8   8Gi        RWO            longhorn       11m
redis-data-redis-replicas-1   Bound    pvc-a8fee53d-1ce1-4ca1-96a0-1d7422dcb8f3   8Gi        RWO            longhorn       9m3s
redis-data-redis-replicas-2   Bound    pvc-b5d53e82-949d-49e7-bd2b-7848a109d211   8Gi        RWO            longhorn       8m14s
```

### Redis client
```
➜  kubernetes-bootstrap git:(main) ✗ export REDIS_PASSWORD=$(kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 --decode)
➜  kubernetes-bootstrap git:(main) ✗ kubectl exec --tty -i redis-client --namespace default -- bash                                                              
I have no name!@redis-client:/$ redis-cli -h redis-master -a $REDIS_PASSWORD
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
redis-master:6379>
```

## Notes
- Might not accessible 100% since sometimes get bad connection.
- Any questions related to access or the setup, feel free to communicate.
