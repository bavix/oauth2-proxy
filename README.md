OAuth2-Proxy (custom theme)

This build injects `@bavix/babichev-design` CSS into oauth2-proxy and uses the local `templates/` folder for custom pages.

How to apply or change the theme
- Edit HTML templates in `templates/` (e.g. `sign_in.html`, `error.html`) to use `pixel-*` classes.
- Rebuild the image:
  - docker build -t oauth2-proxy-babichev .
- Run oauth2-proxy (example using Dex as OIDC provider):
  - export COOKIE_SECRET=$(openssl rand -base64 32 | tr -d '\\n')
  - docker run -d --name oauth2-proxy-demo -p 14180:4180 \
      -e OAUTH2_PROXY_PROVIDER=oidc \
      -e OAUTH2_PROXY_CLIENT_ID=oauth2-proxy \
      -e OAUTH2_PROXY_CLIENT_SECRET=oauth2-proxy-secret \
      -e OAUTH2_PROXY_REDIRECT_URL=http://localhost:14180/oauth2/callback \
      -e OAUTH2_PROXY_OIDC_ISSUER_URL=http://host.docker.internal:5556/dex \
      -e OAUTH2_PROXY_COOKIE_SECRET=\"$COOKIE_SECRET\" \
      oauth2-proxy-babichev
- Open: http://localhost:14180/sign_in

Notes
- The Dockerfile copies `templates/` into the image and pulls the compiled CSS from `@bavix/babichev-design` during build.
- On Linux, replace `host.docker.internal` with the host IP or use Docker network linking so oauth2-proxy can reach Dex.

Based on: https://github.com/oauth2-proxy/oauth2-proxy
