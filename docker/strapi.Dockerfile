FROM arm64v8/node:fermium-slim

WORKDIR /srv

RUN apt-get update&&\
    apt-get install -y\
    build-essential\
    python\
    sqlite3\
    libsqlite3-dev

RUN yarn create strapi-app strapi --no-run --quickstart
RUN yarn --cwd ./strapi install
RUN yarn --cwd ./strapi build

RUN echo 'if [ -f "/app/strapi/package.json" ]; then' >> start.sh
RUN echo '  yarn --cwd /app/strapi && yarn --cwd /app/strapi start' >> start.sh
RUN echo 'else' >> start.sh
RUN echo '  cp -r /srv/strapi /app && yarn --cwd /app/strapi && yarn --cwd /app/strapi start' >> /srv/start.sh
RUN echo 'fi' >> start.sh
RUN chmod +x start.sh

EXPOSE 1337

VOLUME ["/app/strapi"]

CMD ["/srv/start.sh"]