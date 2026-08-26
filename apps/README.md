# Demo servislar

| Servis | Texnologiya | DB testi |
|---|---|---|
| dotnet-api | .NET 8 Minimal API | `/db` |
| python-api | FastAPI | `/db` |
| node-api | Node.js | — |
| go-api | Go | — |
| java-api | Java 21 | — |
| php-api | PHP | — |
| ruby-api | Ruby | — |
| rust-api | Rust | — |
| nginx-web | Nginx | — |
| caddy-web | Caddy | — |
| busybox-web | BusyBox httpd | — |

Hammasi `8080` portda va `/`, `/healthz`, `/readyz` endpointlariga ega. Har papkadagi `values.yaml` umumiy `charts/web-service` chartiga beriladi.

Yangi servis qo‘shish:

1. `apps/yangi-servis` papkasiga kod va Dockerfile yozing.
2. Mavjud `values.yaml`lardan bittasini ko‘chirib, `fullnameOverride`, image va hostni almashtiring.
3. CI matrix va Argo CD ApplicationSet ro‘yxatiga servis nomini kiriting.
4. `helm template` va Docker build bilan tekshiring.

