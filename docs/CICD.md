# CI/CD va GitOps

## Oddiy oqim

```text
git push → test/lint → Docker build → image scan → registry push
         → values.yaml image tag yangilash → Argo CD sync → rollout
```

Image tag `latest` emas, commit SHA bo‘ladi. Shu sabab aynan qaysi kod deploy qilingani va rollback qilinadigan versiya aniq.

## GitHub Actions

- `.github/workflows/reusable-build.yml` — boshqa repo ham chaqira oladigan build shabloni.
- `.github/workflows/ci.yml` — 11 servisni matrix orqali parallel build qiladi.
- Main branch’da image’larni GHCR’ga push qiladi.
- Build muvaffaqiyatli bo‘lsa app `values.yaml` taglarini SHA bilan yangilaydi.
- Argo CD Git’dagi shu o‘zgarishni clusterga olib kiradi.

Repo Settings → Actions’da `Read and write permissions` kerak. Private GHCR image uchun clusterda `imagePullSecret` yarating va chart qiymatida ko‘rsating.

## GitLab CI

- `.gitlab/ci/service-template.yml` — qayta ishlatiladigan job.
- `.gitlab-ci.yml` — `parallel:matrix` orqali barcha servisni build qiladi.
- `deploy-direct` Helm bilan bevosita deploy namunasidir va manual qoldirilgan.
- `KUBE_CONFIG_B64` GitLab’da masked, protected CI variable bo‘lishi kerak.

```bash
base64 -w0 ~/.kube/config
```

Chiqqan qiymatni terminal logiga yoki Git’ga yozmang; faqat GitLab CI variable sifatida kiriting. Production’da uzoq yashaydigan kubeconfig o‘rniga cloud OIDC/workload identity afzal.

## Direct CD va Argo CD farqi

Direct CD’da pipeline cluster credentialiga ega bo‘lib `helm upgrade` qiladi. GitOps’da pipeline faqat image va Git’dagi tagni yangilaydi; cluster ichidagi Argo CD Git’ni kuzatib deploy qiladi. GitOps audit va drift nazorati uchun qulayroq.

