FROM node:20

ENV NODE_ENV=production
ENV APP_USER=
ENV APP_PASS=
ENV SE_TTL=360000
ENV SE_DEBUG=true
ENV SE_TRACE=true
ENV SE_OFFLINE=true
ENV SE_BROWSER_VERSION=130.0.6723.116
ENV SE_DRIVER_VERSION=130.0.6723.116
ENV SE_AVOID_BROWSER_DOWNLOAD=true
ENV SE_CACHE_PATH=/app/.selenium
ENV PATH=$PATH:$SE_CACHE_PATH/chromedriver/linux64/$SE_DRIVER_VERSION/chromedriver:$SE_CACHE_PATH/chrome/linux64/$SE_BROWSER_VERSION/chrome

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
RUN SE_AVOID_BROWSER_DOWNLOAD=false SE_OFFLINE=false ./node_modules/selenium-webdriver/bin/linux/selenium-manager --browser chrome --output SHELL --browser-version $SE_BROWSER_VERSION
RUN chmod +x /app/entrypoint.sh

CMD ["/bin/bash", "/app/entrypoint.sh"]
