# Muhitlar: reusable va ajratilgan

Har bir servis uchun environment nusxasi yaratilmaydi. Qiymatlar qatlamlab qo‘shiladi:

```text
charts/web-service/values.yaml       universal default
apps/<service>/values.yaml           faqat servisga xos image, port, DB talabi
environments/<env>/common.yaml       muhitga xos replica, resource, domain, image tag
```

Infra boshqa chart bo‘lgani uchun har muhitda ikkita alohida override bor:

```text
environments/dev/{common,postgresql,rabbitmq}.yaml
environments/stage/{common,postgresql,rabbitmq}.yaml
environments/prod/{common,postgresql,rabbitmq}.yaml
```

Namespace’lar:

| Muhit | App + PostgreSQL | RabbitMQ | Deploy |
|---|---|---|---|
| dev | `demo-dev` | `messaging-dev` | avtomatik |
| stage | `demo-stage` | `messaging-stage` | avtomatik |
| prod | `demo-prod` | `messaging-prod` | PR + qo‘lda Argo sync |

Ishga tushirish:

```bash
make deploy-all ENV=dev
make deploy-all ENV=stage
make deploy-all ENV=prod
```

Yoki bitta servis:

```bash
helm upgrade --install python-api charts/web-service \
  -n demo-stage --create-namespace \
  -f apps/python-api/values.yaml \
  -f environments/stage/common.yaml
```

Ingress host avtomatik: `<release>.<environment-domain>`. Masalan, stage’da `python-api.stage.example.com`. `database.enabled: true` bo‘lgan app uchun DB host avtomatik `postgres-pooler-rw.<release-namespace>.svc.cluster.local` bo‘ladi.

Promotion ketma-ketligi:

1. CI commit SHA image’larini build qiladi va `dev/common.yaml` tagini yangilaydi.
2. Dev testdan o‘tgach, ayni SHA `stage/common.yaml`ga PR bilan ko‘chiriladi.
3. Stage testdan o‘tgach, ayni SHA `prod/common.yaml`ga PR bilan ko‘chiriladi.
4. Prod Argo CD sync qo‘lda tasdiqlanadi.

Secret har namespace’da alohida yaratiladi; Git’ga ochiq parol yozilmaydi:

```bash
kubectl create secret generic app-db-credentials -n demo-dev \
  --from-literal=username=app --from-literal=password='LOCAL-PAROL'
```

Production’da External Secrets yoki Sealed Secrets ishlating.
