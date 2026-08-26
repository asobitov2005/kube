FROM caddy:2.10-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html healthz readyz /srv/
RUN addgroup -g 10001 app && adduser -D -u 10001 -G app app \
    && chown -R app:app /srv /etc/caddy
ENV XDG_CONFIG_HOME=/tmp/config XDG_DATA_HOME=/tmp/data
USER app
EXPOSE 8080
