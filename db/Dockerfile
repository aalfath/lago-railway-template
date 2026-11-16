# Lago's own PostgreSQL 15 build with the pg_partman extension. A fresh Lago
# database is created from db/structure.sql, which needs pg_partman, so
# Railway's stock Postgres can't be used.
FROM getlago/postgres-partman:15.0-alpine@sha256:27a1e3a1138a69b5a0911ce125dfa613b9ced07604a2d781b9d31141f7f96036

# Data lives in a subfolder of the volume (the volume root holds lost+found).
ENV PGDATA=/var/lib/postgresql/data/pgdata \
    POSTGRES_USER=postgres \
    POSTGRES_DB=lago
