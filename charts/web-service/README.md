# web-service Helm chart

Bitta chart barcha stateless HTTP servislar uchun ishlatiladi. Farq faqat app papkasidagi `values.yaml`da.

```bash
helm template python-api charts/web-service \
  -f apps/python-api/values.yaml -f environments/dev/common.yaml

helm upgrade --install python-api charts/web-service \
  -n demo-dev --create-namespace \
  -f apps/python-api/values.yaml -f environments/dev/common.yaml \
  --wait --atomic
```

Qiymatlar oxirgi fayl bilan override qilinadi. Tartib muhim:

```text
chart values.yaml → app values.yaml → environment values.yaml → --set
```

Asosiy parametrlar:

- `image`: repository, tag va pull policy;
- `replicaCount`: Pod nusxalari;
- `env`, `secretEnv`, `config`: konfiguratsiya;
- `database.enabled`: PgBouncer hosti va credential Secret envlarini avtomatik ulash;
- `probes`: readiness va liveness;
- `resources`: CPU/RAM request va limit;
- `topologySpread`: Podlarni node’lar bo‘ylab tarqatish;
- `podDisruptionBudget`: rejalashtirilgan uzilishda minimal mavjud Pod;
- `autoscaling`: HPA;
- `ingress`: domain va tashqi HTTP trafik;
- `networkPolicy`: kiruvchi trafikni cheklash.

Tarix va rollback:

```bash
helm history python-api -n demo-dev
helm rollback python-api 1 -n demo-dev
helm uninstall python-api -n demo-dev
```
