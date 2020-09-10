# orientdb-helm
Helm chart for OrientDB

To install, make sure the Kubernetes namespace mentioned in `values.yaml` exists and then issue:

```
helm install helmReleaseName path/to/Orientdb/chart --set image.repository=pxsalehi/orientdb --set image.tag=3.1.3-snapshot --set servers=numberOfServers
```


You can scale up/down the OrientDB cluster using `upgrade`:
```
helm upgrade helmReleaseName path/to/Orientdb/chart --set image.repository=pxsalehi/orientdb --set image.tag=3.1.3-snapshot --set servers=differentNumberOfServers
```


By default a PVC for backup is not created. To do so set `volumes.backup.mount` to `true`.

