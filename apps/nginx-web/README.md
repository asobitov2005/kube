# nginx-web

Nginx unprivileged image asosidagi statik web servis.

```bash
docker build -t ghcr.io/asobitov2005/kube-nginx-web:local apps/nginx-web
helm upgrade --install nginx-web charts/web-service -n demo-apps --create-namespace \
  -f apps/nginx-web/values.yaml -f environments/dev.yaml
kubectl port-forward -n demo-apps service/nginx-web 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall nginx-web -n demo-apps`.

