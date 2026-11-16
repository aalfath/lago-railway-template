# Lago web app (nginx on port 8080). Its start script writes API_URL into the
# app's runtime config, so the browser talks to the lago-api public domain.
FROM getlago/front:v1.57.0@sha256:17458dbd65597dc5ec3f76fd781f12df119856140999e0fbb119fd3dd2464fe0

ENV APP_ENV=production \
    LAGO_OAUTH_PROXY_URL=https://proxy.getlago.com
