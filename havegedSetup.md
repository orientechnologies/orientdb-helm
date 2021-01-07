Java's `SecureRandom` might block due to not enough random bytes available from `/dev/random`. To address this problem, 
you could start a [haveged](https://wiki.archlinux.org/index.php/Haveged) on each node.

To create an image, you can build one as follows:
``` dockerfile
FROM alpine
RUN apk --no-cache add haveged
ENTRYPOINT ["haveged"]
CMD ["-F"]
```

Next, you can create a DaemonSet on the kubernetes cluster to ensure that each node has a haveged running. Note that, 
this requires a privileged container.
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: haveged-dset
  namespace: default
spec:
  selector:
    matchLabels:
      name: haveged
  template:
    metadata:
      labels:
        name: haveged
    spec:
      containers:
      - name: haveged
        image: pxsalehi/haveged
        securityContext:
          privileged: true
```