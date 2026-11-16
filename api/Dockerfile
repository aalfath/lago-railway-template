# Lago API (Rails + Puma). Migrates the database, seeds the first organization
# and admin user (LAGO_ORG_USER_EMAIL / LAGO_ORG_USER_PASSWORD), then serves on PORT.
FROM getlago/api:v1.57.0@sha256:24678b61b372e5ca02f9bb4687c9aec012f8ba8a3539d28c4cbe989f131f3aed

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    LAGO_SIDEKIQ_WEB=false \
    LAGO_CREATE_ORG=true \
    LAGO_USE_AWS_S3=true \
    LAGO_OAUTH_PROXY_URL=https://proxy.getlago.com

COPY railway-entrypoint.sh rsa-key.rb /railway/
ENTRYPOINT ["/railway/railway-entrypoint.sh"]
CMD ["/app/scripts/start.sh"]
