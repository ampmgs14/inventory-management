FROM postgres:15

ENV POSTGRES_USER=asset
ENV POSTGRES_PASSWORD=asset
ENV POSTGRES_DB=assetdb

COPY init.sql /docker-entrypoint-initdb.d/
