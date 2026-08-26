# Argo CD

Argo CD Git’dagi kerakli holatni cluster holati bilan solishtiradi. Bu yerda Helm faqat template render qiladi; install/upgrade lifecycle’ni Argo CD boshqaradi.

Operatorlar va `app-db-credentials` Secret avval o‘rnatilgan bo‘lishi kerak. Secret’ni Git’ga ochiq ko‘rinishda commit qilmang; production’da External Secrets yoki Sealed Secrets ishlating.

```bash
kubectl apply -n argocd -f gitops/argocd/apps-nonprod.yaml
kubectl apply -n argocd -f gitops/argocd/apps-prod.yaml
kubectl apply -n argocd -f gitops/argocd/infra-nonprod.yaml
kubectl apply -n argocd -f gitops/argocd/infra-prod.yaml
kubectl get applications -n argocd
```

Dev/stage avtomatik sync va self-heal qiladi. Production manifestlarida automated sync yo‘q: Git’dagi prod tag PR bilan yangilanadi, keyin operator sync’ni tasdiqlaydi. `Prune=false` DB va RabbitMQ ma’lumotli resurslarini himoya qiladi.
