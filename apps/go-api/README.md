# go-api

Go standard kutubxonasi bilan yozilgan kichik HTTP API. Final image distroless va non-root.

```bash
docker build -t ghcr.io/asobitov2005/kube-go-api:local apps/go-api
helm upgrade --install go-api charts/web-service -n demo-apps --create-namespace \
  -f apps/go-api/values.yaml -f environments/dev.yaml
kubectl port-forward -n demo-apps service/go-api 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall go-api -n demo-apps`.

