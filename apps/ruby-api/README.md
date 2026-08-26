# ruby-api

Ruby standard kutubxonasi bilan minimal HTTP API.

```bash
docker build -t ghcr.io/asobitov2005/kube-ruby-api:local apps/ruby-api
helm upgrade --install ruby-api charts/web-service -n demo-apps --create-namespace \
  -f apps/ruby-api/values.yaml -f environments/dev.yaml
kubectl port-forward -n demo-apps service/ruby-api 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall ruby-api -n demo-apps`.

