# syntax=docker/dockerfile:1.7
ARG PG_MAJOR=17
FROM postgres:${PG_MAJOR}

# Tuned config + init scripts (init runs only on first volume init)
COPY docker/postgres.conf /etc/postgresql/postgresql.conf
COPY docker/initdb/ /docker-entrypoint-initdb.d/