FROM node:20

ENV NODE_ENV=production
ENV APP_USER=
ENV APP_PASS=
ENV SE_TTL=36000000
ENV SE_DEBUG=true
ENV SE_TRACE=true
ENV SE_BROWSER_VERSION=130
ENV SE_AVOID_BROWSER_DOWNLOAD=true

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
RUN SE_AVOID_BROWSER_DOWNLOAD=false ./node_modules/selenium-webdriver/bin/linux/selenium-manager --browser chrome
RUN chmod +x /app/entrypoint.sh
RUN export

CMD ["/bin/bash", "/app/entrypoint.sh"]
