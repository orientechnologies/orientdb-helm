# orientdb-helm
Helm chart for OrientDB

To install, make sure the Kubernetes namespace mentioned in `values.yaml` exists and then issue:

`helm install helmReleaseName pathToOrientdbHelmChart --set image.repository=pxsalehi/orientdb --set image.tag=3.1.2 --set master.replicas=numberOfMasters`
