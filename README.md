# Qayta ishlatiladigan Kubernetes deployment laboratoriyasi

Repo 11 ta minimal web servisni bitta umumiy Helm chart orqali deploy qilishni, PostgreSQL HA + PgBouncer, RabbitMQ HA, GitHub/GitLab CI va Argo CD GitOps oqimini ko‘rsatadi. Barcha izohlar o‘zbek tilida.

## Tuzilishi

```text
apps/                 11 servis: kod, Dockerfile, values.yaml, README
charts/web-service/   barcha stateless web servislar uchun umumiy chart
charts/postgresql-ha/ CloudNativePG + PgBouncer Pooler
charts/rabbitmq-ha/   RabbitMQ Cluster Operator charti
environments/         dev, stage, prod uchun umumiy app va infra qiymatlari
gitops/argocd/        ApplicationSet va infrastructure Applications
.github/workflows/    GitHub Actions reusable CI
.gitlab/ci/           GitLab reusable CI job
docs/                 CI/CD, termin va production izohlari
```

## Talablar

```bash
docker version
kubectl version --client
helm version
kind version
```

Ubuntu’da Helm va kind yo‘q bo‘lsa:

```bash
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/v0.32.0/kind-linux-amd64
chmod +x /tmp/kind
sudo mv /tmp/kind /usr/local/bin/kind
```

Cluster mavjud bo‘lsa `kind` shart emas. Yangi 3-node local cluster:

```bash
make cluster
kubectl get nodes -o wide
```

## Bitta servisni ishga tushirish

```bash
docker build -t ghcr.io/asobitov2005/kube-python-api:local apps/python-api
kind load docker-image --name kube-lab ghcr.io/asobitov2005/kube-python-api:local

helm upgrade --install python-api charts/web-service \
  -n demo-dev --create-namespace \
  -f apps/python-api/values.yaml \
  -f environments/dev/common.yaml \
  --wait --atomic

kubectl port-forward -n demo-dev service/python-api 8080:80
```

Boshqa terminal:

```bash
curl http://localhost:8080/
curl http://localhost:8080/healthz
```

## Hammasini ishga tushirish

Bu build ko‘p image yuklaydi va vaqt/disk talab qiladi:

```bash
make build-all
make load-kind
make deploy-all
make status
```

## Yangi loyihada qayta ishlatish

Deployment YAMLni ko‘chirmang. Faqat app kodi/Dockerfile va shunday kichik values yarating:

```yaml
fullnameOverride: mening-api
image:
  repository: ghcr.io/tashkilot/mening-api
  tag: local
containerPort: 8080
```

```bash
helm upgrade --install mening-api charts/web-service \
  -n mening-loyiham --create-namespace \
  -f apps/mening-api/values.yaml \
  -f environments/dev/common.yaml
```

Chart hostni release nomi va muhit domenidan avtomatik yaratadi. DB kerak bo‘lsa app values ichida faqat `database.enabled: true` qo‘yiladi. Muhit tuzilishi va promotion: [environments/README.md](environments/README.md).

## kubectl, Helm va Argo CD

| Xususiyat | kubectl | Helm | Argo CD |
|---|---|---|---|
| Vazifa | Tayyor YAMLni API’ga yuboradi | Template + values’dan YAML yaratadi va release boshqaradi | Git’dagi kerakli holatni cluster bilan doimiy solishtiradi |
| Muhitlar | Kustomize yoki alohida manifest/patch | Bir chart + `values-dev/stage/prod` | Git branch/path + Helm values |
| O‘chirish | `kubectl delete -f papka/` | `helm uninstall release` | Git’dan olib tashlash + prune |
| Tarix | Deployment rollout tarixi bor, butun paket tarixi emas | Release revision va `helm rollback` | Git tarixi + sync tarixi |
| Drift | Faqat qayta apply/tekshiruv bilan | Upgrade vaqtida | Doimiy aniqlaydi, `selfHeal` bilan tuzatadi |

`kubectl` bilan ham bir papkani `kubectl delete -f papka/` orqali birdan o‘chirish mumkin. Helmning asosiy yutug‘i faqat delete emas, parametrli paket, release tarixi va qayta foydalanishdir.

## Data layer

PostgreSQL/PgBouncer: [charts/postgresql-ha/README.md](charts/postgresql-ha/README.md).

RabbitMQ: [charts/rabbitmq-ha/README.md](charts/rabbitmq-ha/README.md).

FastAPI va .NET uchun chart `DB_HOST=postgres-pooler-rw.<joriy-namespace>.svc.cluster.local` qiymatini avtomatik yaratadi. `/db` endpoint `SELECT 1` bilan ulanishni tekshiradi.

## CI/CD va Argo CD

- [CI/CD qo‘llanmasi](docs/CICD.md)
- [Argo CD qo‘llanmasi](gitops/argocd/README.md)
- [Terminlar](docs/TERMINLAR.md)
- [Production chegaralari](docs/PRODUCTION.md)

Production’da image tagni commit SHA yoki digest bilan pin qiling. Parol/tokenlarni Git’ga yozmang.

## Tozalash

Stateless servislar:

```bash
make remove-all
```

PostgreSQL va RabbitMQ default holatda o‘chirishdan himoyalangan. Ularni o‘chirishdan oldin backup/restore’ni tekshiring. Local kind clusterni butunlay o‘chirish barcha local storage’ni ham yo‘qotadi:

```bash
kind delete cluster --name kube-lab
```
