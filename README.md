# orientdb-helm
Helm chart for OrientDB

To install, make sure the Kubernetes namespace mentioned in `values.yaml` exists and then issue:

```
helm install helmReleaseName path/to/Orientdb/chart --set image.repository=pxsalehi/orientdb --set image.tag=3.1.2 --set servers=numberOfServers
```

You can scale up/down the OrientDB cluster using `upgeade`:
```
helm upgrade helmReleaseName path/to/Orientdb/chart --set image.repository=pxsalehi/orientdb --set image.tag=3.1.2 --set servers=differentNumberOfServers
```

