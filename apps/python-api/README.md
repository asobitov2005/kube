# python-api

FastAPI servisi. `/`, `/healthz`, `/readyz`, `/docs` va PostgreSQL/PgBouncer uchun `/db` endpointlari bor.

```bash
docker build -t ghcr.io/asobitov2005/kube-python-api:local apps/python-api
helm upgrade --install python-api charts/web-service \
  -n demo-dev --create-namespace \
  -f apps/python-api/values.yaml -f environments/dev/common.yaml
kubectl port-forward -n demo-dev service/python-api 8080:80
curl http://localhost:8080/
```

DB o‘rnatilgach `curl http://localhost:8080/db`. Ulanish PgBouncer orqali, credential esa Secret orqali beriladi.

O‘chirish: `helm uninstall python-api -n demo-dev`.
