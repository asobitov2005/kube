# caddy-web

Caddy asosidagi statik web servis. Container non-root ishlaydi, runtime data esa `/tmp` volume ichiga yoziladi.

```bash
docker build -t ghcr.io/asobitov2005/kube-caddy-web:local apps/caddy-web
helm upgrade --install caddy-web charts/web-service -n demo-apps --create-namespace \
  -f apps/caddy-web/values.yaml -f environments/dev.yaml
kubectl port-forward -n demo-apps service/caddy-web 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall caddy-web -n demo-apps`.
