FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY --chown=101:101 index.html healthz readyz /usr/share/nginx/html/
EXPOSE 8080

