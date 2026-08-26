FROM ruby:3.3-alpine
WORKDIR /app
RUN addgroup -g 10001 app && adduser -D -u 10001 -G app app
COPY --chown=app:app server.rb .
USER app
EXPOSE 8080
CMD ["ruby", "server.rb"]

