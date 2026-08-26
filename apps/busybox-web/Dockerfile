FROM busybox:1.37
WORKDIR /www
COPY index.html healthz readyz ./
USER 65534:65534
EXPOSE 8080
CMD ["httpd", "-f", "-p", "8080", "-h", "/www"]
