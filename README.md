# orientdb-helm
Helm chart for OrientDB (version >= 3.1.3).

> **Disclaimer**: This Helm chart is provided for testing purposes only or trying out OrientDB CE on Kubernetes. This Helm chart is not part of any official OrientDB release and it is only supported by community contributions. For any issues/questions please use the GitHub Issues.

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
|`ssl.enable`|`false`|Enable TLS connections to server (HTTPS and binary)|
|`ssl.keyStoreFile`||Path to keystore file for TLS|
|`ssl.keyStorePassword`||Password of the provided keystore|
|`ssl.trustStoreFile`||Path to truststore file for TLS|
|`ssl.trustStorePassword`||Password of the provided truststore|
|`ssl.clientAuth`|`false`|Whether to use mutual TLS authentication with clients|

## OrientDB and Gremlin / TinkerPop

To enable running Gremlin queries via OrientDB Studio, you should use an OrientDB distribution with TinkerPop3 support, and enable Gremlin server-side script:
```
helm install helm-release-name path/to/Orientdb/chart --set image.tag=3.1.9-tp3 --set "serverSideScript.allowedLanguages={SQL,Gremlin}"
```

> Using the helm chart for deploying non-CE OrientDB distributions (e.g., EE, TinkerPop) requires the corresponding docker image to be passed as the parameter to the Helm chart.  For OrientDB with TinkerPop3 an official docker image is provided, e.g. from [here](https://github.com/orientechnologies/orientdb-docker/blob/master/3.0-tp3/x86_64/alpine/gremlin-server.yaml).

## Custom configuration

When providing custom config files to the Helm chart, note that Helm cannot access files located outside of the chart directory or under the templates directory.

Other configurations that can be set are:
* Attaching custom labels and annotations to the resources created by the chart.
* Defining resource limits and requests.
* Override default configurations defined in OrientDB configuration files such as `hazelcast.xml`, `orientdb-server-config.xml`, ` default-distributed-db-config.json`, etc.

## Multi-master

OrientDB supports a multi-master (a.k.a. master-less) architecture. Therefore, it might be useful to expose each OrientDB instance in the cluster separately. As all instance are part of the same StatefulSet, one simple approach would to create one service per instance that uses the naming convention of StatefulSets `statefulSetName-0`, `statefulSetName-1`, ... 

To do so the service could use a Pod selector similar to the following:
```
"statefulset.kubernetes.io/pod-name": "statefulSetName-0"
``` 

## Security

To deploy with TLS enabled, you should deploy the chart with `ssl.enable=true` and provide the keystore and truststore files and password. You can find more information on how to setup TLS in the [official OrientDB documentations.](http://orientdb.org/docs/3.1.x/security/Using-SSL-with-OrientDB.html)

In case there is not enough entropy available on `/dev/random` the startup of the server might block. You could [deploy a haveged daemon](./havegedSetup.md) to address this issue.

**TODOs**

- [ ] add helm chart to repository for testing
- [ ] document EE 

