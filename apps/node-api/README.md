# node-api

Dependency’siz Node.js HTTP demo. `/`, `/healthz` va `/readyz` ishlaydi.

```bash
docker build -t ghcr.io/asobitov2005/kube-node-api:local apps/node-api
helm upgrade --install node-api charts/web-service -n demo-dev --create-namespace \
  -f apps/node-api/values.yaml -f environments/dev/common.yaml
kubectl port-forward -n demo-dev service/node-api 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall node-api -n demo-dev`.
