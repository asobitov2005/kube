# Production eslatmalari

Bu repo production tamoyillarini ko‘rsatadi, ammo cloud/providerga xos quyidagilarni siz tanlaysiz:

- kamida 3 worker va zone bo‘yicha tarqatish;
- replicated CSI StorageClass va `Retain` reclaim policy;
- Ingress Controller, DNS va cert-manager/TLS;
- External Secrets, Vault yoki cloud secret manager;
- Prometheus/Grafana, markaziy log va alertlar;
- NetworkPolicy ishlata oladigan CNI;
- image vulnerability scan va imzo;
- PostgreSQL backup/PITR va muntazam restore testi;
- RabbitMQ durable quorum queue, persistent messages va publisher confirms;
- disaster recovery, RPO/RTO va upgrade runbook.

PVC Pod restartidan keyin ma’lumotni saqlaydi, lekin disk/backend/region yo‘qolishiga qarshi avtomatik kafolat bermaydi. Uch DB replica ham backupsiz yetarli emas. “O‘chib ketmaydi” natijasi replica + mustaqil backup + sinovdan o‘tgan restore bilan olinadi.

Kubernetes Secret base64 bilan yashirilgani encryption degani emas. Secret manifestini Git’ga commit qilmang; etcd encryption-at-rest va eng kam RBAC huquqlarini yoqing.

