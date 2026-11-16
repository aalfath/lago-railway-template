# Lago on Railway

A Railway template for [Lago](https://github.com/getlago/lago), the open-source billing and metering platform (usage-based billing, subscriptions, invoices). It deploys **Lago v1.57.0** with the upstream images pinned by digest.

## What it deploys

| Service | Built from | Role |
|---|---|---|
| `lago-front` | `front/` (`getlago/front:v1.57.0`) | Web app, public domain, port 8080 |
| `lago-api` | `api/` (`getlago/api:v1.57.0`) | REST + GraphQL API, public domain, port 3000. Runs the database migrations and creates the first organization and admin user on boot |
| `lago-worker` | `worker/` (`getlago/api:v1.57.0`) | Sidekiq background jobs: invoices, PDFs, webhooks, events |
| `lago-clock` | `clock/` (`getlago/api:v1.57.0`) | Scheduler for the periodic billing jobs |
| `lago-pdf` | `pdf/` (`ghcr.io/getlago/lago-gotenberg:8.39`) | Gotenberg, renders invoice PDFs (private only) |
| `Postgres` | `db/` (`getlago/postgres-partman:15.0-alpine`) | PostgreSQL 15 with `pg_partman`, which a fresh Lago database needs. Volume at `/var/lib/postgresql/data` |
| `Redis` | Railway Redis | Job queue and cache |
| `Bucket` | Railway Bucket (S3) | Invoice PDFs and other files, shared by the API and the worker |

## First login

1. Deploy and enter `LAGO_ORG_USER_EMAIL` (the admin's email). That is the only prompt.
2. Open the `lago-front` domain and sign in with that email and the password in the `lago-api` service's `LAGO_ORG_USER_PASSWORD` variable (generated per deploy).
3. Your organization's API key is in **Developers → API keys**. The API's base URL is the `lago-api` domain.

Public sign-up is off (`LAGO_DISABLE_SIGNUP=true`), so strangers can't create organizations on your instance. The admin user and organization are created once: changing `LAGO_ORG_USER_PASSWORD` later does not change the password (change it in the app), and changing `LAGO_ORG_NAME` creates a second organization.

## Variables

All secrets are generated per deploy (`SECRET_KEY_BASE`, the three `LAGO_ENCRYPTION_*` keys, the Postgres password, the admin password). `lago-worker` and `lago-clock` reference `lago-api`'s values, so set shared values on `lago-api`.

Optional, add them on `lago-api` and `lago-worker` when you need them (see [Lago's environment variables](https://getlago.com/docs/guide/lago-self-hosted/docker#environment-variables)):

- Email: `LAGO_FROM_EMAIL`, `LAGO_SMTP_ADDRESS`, `LAGO_SMTP_PORT`, `LAGO_SMTP_USERNAME`, `LAGO_SMTP_PASSWORD`
- Google sign-in: `GOOGLE_AUTH_CLIENT_ID`, `GOOGLE_AUTH_CLIENT_SECRET`
- Premium license: `LAGO_LICENSE`

## How the template works around Railway's limits

- **No shared volumes on Railway.** Upstream's Docker Compose shares one `storage` volume between the API and the worker. Here both use a Railway Bucket through Lago's S3 settings (`LAGO_USE_AWS_S3=true`), so a PDF made by the worker can be downloaded through the API.
- **Webhook signing key.** Lago needs an RSA key (`LAGO_RSA_PRIVATE_KEY`) shared by the API, worker and clock. Railway can't generate one as a variable, so the first service to boot generates it and stores it in Postgres (schema `railway_template`); every service reads it from there on each boot. To use your own key, set `LAGO_RSA_PRIVATE_KEY` (base64 of the PEM) on all three services.
- **Sidekiq's web UI is off** (`LAGO_SIDEKIQ_WEB=false`), because it has no login of its own.

## Updates

Each service's `Dockerfile` pins its upstream image by version and digest. A new Lago release lands here as a change to those pins plus a `CHANGELOG.md` entry, merged to `main`. Railway then shows an "update available" notice to everyone who deployed the template, and you choose when to apply it. Read `CHANGELOG.md` first: Lago runs its database migrations on the API's first boot after an update.

`lago-pdf` pins `ghcr.io/getlago/lago-gotenberg`. If upstream ever removes that tag from GHCR, the PDF service stops building until the pin is bumped here.

## Local test

The images run anywhere Docker runs. Upstream's own self-hosting guide: <https://getlago.com/docs/guide/lago-self-hosted/docker>.

## License

Lago is AGPL-3.0 ([getlago/lago](https://github.com/getlago/lago)). This repo only holds the Railway wrapper (Dockerfiles and a start script).
