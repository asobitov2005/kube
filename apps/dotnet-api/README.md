# dotnet-api

.NET 8 Minimal API. `/`, `/healthz`, `/readyz` va PostgreSQL/PgBouncer uchun `/db` endpointlari bor.

```bash
docker build -t ghcr.io/asobitov2005/kube-dotnet-api:local apps/dotnet-api
helm upgrade --install dotnet-api charts/web-service \
  -n demo-dev --create-namespace \
  -f apps/dotnet-api/values.yaml -f environments/dev/common.yaml
kubectl port-forward -n demo-dev service/dotnet-api 8080:80
curl http://localhost:8080/
```

DB o‘rnatilgach `curl http://localhost:8080/db`. `DB_HOST` PgBouncer Service’ga qaraydi; parol Git’da emas, `app-db-credentials` Secret’da turadi.

O‘chirish: `helm uninstall dotnet-api -n demo-dev`.
