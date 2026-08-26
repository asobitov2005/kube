# PostgreSQL HA va PgBouncer

Bu chart CloudNativePG Operator orqali PostgreSQL va native `Pooler` resursi orqali PgBouncer yaratadi.

## Local

```bash
kubectl apply --server-side -f \
  https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.28/releases/cnpg-1.28.4.yaml
kubectl rollout status deployment/cnpg-controller-manager -n cnpg-system
kubectl create namespace demo-apps --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic app-db-credentials -n demo-apps \
  --from-literal=username=app \
  --from-literal=password='LOCAL-PAROLNI-ALMASHTIRING'
helm upgrade --install postgres charts/postgresql-ha \
  -n demo-apps -f charts/postgresql-ha/values.yaml --wait
```

```bash
kubectl get cluster,pooler,pod,pvc -n demo-apps
kubectl get service postgres-pooler-rw -n demo-apps
```

`postgres-pooler-rw:5432` ilovalar uchun kirish nuqtasi. PgBouncer ko‘p client ulanishlarini kamroq PostgreSQL ulanishlariga birlashtiradi. `transaction` rejimida connection faqat transaction davomida clientga biriktiriladi.

## Production

```bash
helm upgrade --install postgres charts/postgresql-ha -n demo-apps \
  -f charts/postgresql-ha/values.yaml \
  -f charts/postgresql-ha/values-production.yaml --wait
```

`fast-retain` namuna nom: real CSI StorageClass nomiga almashtiring. Uch replica va PVC node/zone yo‘qolishidan faqat storage backend ham replika qilsa himoya qiladi. Backupni alohida bucket yoki ishlaydigan VolumeSnapshotClass bilan sozlang va restore’ni muntazam sinang.

`protectFromDeletion` Helm uninstall va Argo CD prune’dan Cluster’ni saqlaydi. Bu backup o‘rnini bosmaydi. Ataylab o‘chirishdan oldin backup oling, so‘ng himoya annotationlarini olib tashlang.

