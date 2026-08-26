# rust-api

Rust standard kutubxonasi bilan minimal HTTP API.

```bash
docker build -t ghcr.io/asobitov2005/kube-rust-api:local apps/rust-api
helm upgrade --install rust-api charts/web-service -n demo-apps --create-namespace \
  -f apps/rust-api/values.yaml -f environments/dev.yaml
kubectl port-forward -n demo-apps service/rust-api 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall rust-api -n demo-apps`.

