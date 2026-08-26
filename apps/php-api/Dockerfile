FROM php:8.3-cli-alpine
WORKDIR /app
RUN addgroup -g 10001 app && adduser -D -u 10001 -G app app
COPY --chown=app:app index.php .
USER app
EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "index.php"]

