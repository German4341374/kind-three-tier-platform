FROM node:22.14.0-alpine3.21 AS assets
WORKDIR /assets
COPY index.html app.js styles.css ./

FROM nginxinc/nginx-unprivileged:1.27.5-alpine AS runtime
COPY --from=assets /assets /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
USER 101:101
EXPOSE 8080
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -q -O - http://127.0.0.1:8080/healthz || exit 1
