# Lago background jobs (Sidekiq): invoices, PDFs, webhooks, events.
FROM getlago/api:v1.57.0@sha256:24678b61b372e5ca02f9bb4687c9aec012f8ba8a3539d28c4cbe989f131f3aed

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    LAGO_SIDEKIQ_WEB=false \
    LAGO_USE_AWS_S3=true \
    LAGO_OAUTH_PROXY_URL=https://proxy.getlago.com

COPY railway-entrypoint.sh rsa-key.rb /railway/
ENTRYPOINT ["/railway/railway-entrypoint.sh"]
CMD ["/app/scripts/start.worker.sh"]
