FROM node:20

ENV NODE_ENV=production
ENV APP_USER=
ENV APP_PASS=

WORKDIR /app

RUN apt-get update -qq -y && \
    apt-get install -y \
        vim \
        libasound2 \
        libatk-bridge2.0-0 \
        libgtk-4-1 \
        libnss3 \
        xdg-utils \
        wget

ADD . /app/

# install dependencies
RUN npm install --omit=dev
RUN npm install pm2 -g
RUN ./node_modules/selenium-webdriver/bin/linux/selenium-manager --browser chrome
RUN chmod +x /app/entrypoint.sh

CMD ["/bin/bash", "/app/entrypoint.sh"]
