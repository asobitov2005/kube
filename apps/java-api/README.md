# java-api

Java 21 built-in HTTP server demo; framework ishlatilmagan, deployment tushunchalariga urg‘u berilgan.

```bash
docker build -t ghcr.io/asobitov2005/kube-java-api:local apps/java-api
helm upgrade --install java-api charts/web-service -n demo-dev --create-namespace \
  -f apps/java-api/values.yaml -f environments/dev/common.yaml
kubectl port-forward -n demo-dev service/java-api 8080:80
curl http://localhost:8080/
```

O‘chirish: `helm uninstall java-api -n demo-dev`.
