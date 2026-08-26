FROM rust:1.86-alpine AS build
WORKDIR /src
COPY main.rs .
RUN rustc -C opt-level=3 -C strip=symbols -o /server main.rs

FROM alpine:3.21
RUN addgroup -g 10001 app && adduser -D -u 10001 -G app app
COPY --from=build --chown=app:app /server /server
USER app
EXPOSE 8080
ENTRYPOINT ["/server"]

