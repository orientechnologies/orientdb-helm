# orientdb-helm
Helm chart for OrientDB

To install, make sure the Kubernetes namespace mentioned in `values.yaml` exists and then issue:

```
helm install helm-release-name path/to/Orientdb/chart
```


You can scale up/down the OrientDB cluster using `upgrade`. For example to change the cluster size to 3:
```
helm upgrade helm-release-name path/to/Orientdb/chart --set servers=3
```


By default a PVC for backup is not created. To do so set `volumeClaims.backup.mount` to `true`.

To delete the OrientDB cluster issue:
```
helm delete helm-release-name
```

Note that deleting the Helm release doesn't delete the PVCs created and therefore the PVs will not be released. To do so, you'd need to explicitly remove the PVCs.

