# php-api

PHP built-in server bilan minimal JSON API.

```bash
docker build -t ghcr.io/asobitov2005/kube-php-api:local apps/php-api
helm upgrade --install php-api charts/web-service -n demo-dev --create-namespace \
  -f apps/php-api/values.yaml -f environments/dev/common.yaml
kubectl port-forward -n demo-dev service/php-api 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall php-api -n demo-dev`.
