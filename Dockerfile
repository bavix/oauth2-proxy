FROM node:20-alpine AS build
WORKDIR /build
COPY package.json package-lock.json* ./
RUN npm ci --production --no-audit --no-fund || npm install --production --no-audit --no-fund
RUN /bin/sh -lc "mkdir -p /build/out && cp node_modules/@bavichev/babichev-design/dist/styles/main.css /build/out/babichev-design.css || true && printf '%s\n' '{{define \"babichev-design.css\"}}' > /build/out/babichev-design.tmpl && cat /build/out/babichev-design.css >> /build/out/babichev-design.tmpl && printf '%s\n' '{{end}}' >> /build/out/babichev-design.tmpl || true"

FROM quay.io/oauth2-proxy/oauth2-proxy:v7.13.0
COPY templates/ /templates/
COPY --from=build /build/out/babichev-design.tmpl /templates/babichev-design.tmpl
ENV OAUTH2_PROXY_CUSTOM_TEMPLATES_DIR=/templates
