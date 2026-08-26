# Argo CD

Argo CD Git’dagi kerakli holatni cluster holati bilan solishtiradi. Bu yerda Helm faqat template render qiladi; install/upgrade lifecycle’ni Argo CD boshqaradi.

Operatorlar va `app-db-credentials` Secret avval o‘rnatilgan bo‘lishi kerak. Secret’ni Git’ga ochiq ko‘rinishda commit qilmang; production’da External Secrets yoki Sealed Secrets ishlating.

```bash
kubectl apply -n argocd -f gitops/argocd/applicationset.yaml
kubectl apply -n argocd -f gitops/argocd/postgresql.yaml
kubectl apply -n argocd -f gitops/argocd/rabbitmq.yaml
kubectl get applications -n argocd
```

`selfHeal: true` clusterda qo‘lda qilingan drift’ni Git holatiga qaytaradi. `prune: true` Git’dan olib tashlangan stateless resursni cluster’dan ham o‘chiradi. DB va RabbitMQ CR’larida `Prune=false` himoyasi bor.

