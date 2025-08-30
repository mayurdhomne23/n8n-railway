FROM node:18-alpine

ARG N8N_VERSION=1.56.1

RUN apk add --update graphicsmagick tzdata

USER root

RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} && \
    apk del build-dependencies

WORKDIR /data

EXPOSE $PORT

ENV N8N_USER_ID=root
ENV DB_TYPE=postgresdb
ENV NODE_FUNCTION_ALLOW_EXTERNAL=pg

CMD ["/bin/sh", "-c", "\
    export N8N_PORT=$PORT && \
    export DB_POSTGRESDB_HOST=$PGHOST && \
    export DB_POSTGRESDB_PORT=$PGPORT && \
    export DB_POSTGRESDB_DATABASE=$PGDATABASE && \
    export DB_POSTGRESDB_USER=$PGUSER && \
    export DB_POSTGRESDB_PASSWORD=$PGPASSWORD && \
    n8n start"]
