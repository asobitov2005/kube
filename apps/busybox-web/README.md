# busybox-web

BusyBox `httpd` bilan eng kichik statik web servis.

```bash
docker build -t ghcr.io/asobitov2005/kube-busybox-web:local apps/busybox-web
helm upgrade --install busybox-web charts/web-service -n demo-dev --create-namespace \
  -f apps/busybox-web/values.yaml -f environments/dev/common.yaml
kubectl port-forward -n demo-dev service/busybox-web 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall busybox-web -n demo-dev`.
