# Changelog

## 1.57.0-railway.1 (2026-11-16)

- First release of the Railway template: Lago v1.57.0 (`getlago/api` and `getlago/front` v1.57.0, `lago-gotenberg` 8.39, `postgres-partman` 15.0-alpine), all pinned by digest.
- Services: front, API, worker, clock, PDF, Postgres (with `pg_partman`), Redis, and a Railway Bucket for files.
- The first organization and admin user are created on the API's first boot; public sign-up is off.
