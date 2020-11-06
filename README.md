# orientdb-helm
Helm chart for OrientDB.

To install, make sure the Kubernetes namespace mentioned in `values.yaml` exists and then issue:

```
helm install helm-release-name path/to/Orientdb/chart
```


You can scale up/down the OrientDB cluster using `upgrade`. For example to change the cluster size to 3:
```
helm upgrade helm-release-name path/to/Orientdb/chart --set servers=3
```

To delete the OrientDB cluster issue:
```
helm delete helm-release-name
```

Note that deleting the Helm release does not delete the PVCs created and therefore the PVs will not be released. To do so, you'd need to explicitly remove the PVCs.

Some of the parameters that can be changed/passed to the helm chart:

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| `volumeClaims.backup.mount`| `false` | Create a PVC for backup |
|`servers`|`3`|Number of OrientDB instances in the cluster|
|`createRootUser`|`true`|Create the `root` user on each server|
|`rootPassword`|`root`|Password for the `root` user|
|`environmentVariables`|`[]`|List of environment variables passed to the server. This could be used to change the JVM heap size for example|
|`image.repository`|`orientdb`|Image repository and name. E.g. `repo/customOrient`|
|`serviceAccount.create`|`true`|Whether to create the kubernetes service account used by Hazelcast. If false, it must already exist, and its name must be provided using `serviceAccount.name`|
|`volumeClaims.databases`|No storage class and `2Gi`|storage class and size of the PV to use for storing databases|
|`service.nodePort.create`|`false`|Create a `NodePort` service exposing binary and HTTP port of all instances |
|`tryAvoidingColocation` | `false` | If true, try to spread the OrientDB instances evenly across the cluster nodes |
|`statefulSetName`|`orientdb`|Name of the StatefulSet created|
|`security.customSecurityConfigFile`| |If provided, the content of this file is used for `security.json`|
|`log.customLogPropertiesFile`| |If provided, the content of this file is used for `orientdb-server-log.properties`|
|`automaticBackup.customBackupConfigFile`| |If provided, the content of this file is used for `automatic-backup.json` to configure automatic backup|

When providing custom config files to the Helm chart, note that Helm cannot access files located outside of the chart directory or under the templates directory.

Other configurations that can be set are:
* Attaching custom labels and annotations to the resources created by the chart.
* Defining resource limits and requests.
* Override default configurations defined in OrientDB configuration files such as `hazelcast.xml`, `orientdb-server-config.xml`, ` default-distributed-db-config.json`, etc.

OrientDB supports a multi-master (a.k.a. master-less) architecture. Therefore, it might be useful to expose each OrientDB instance in the cluster separately. As all instance are part of the same StatefulSet, one simple approach would to create one service per instance that uses the naming convention of StatefulSets `statefulSetName-0`, `statefulSetName-1`, ... 

To do so the service could use a Pod selector similar to the following:
```
"statefulset.kubernetes.io/pod-name": "statefulSetName-0"
``` 
