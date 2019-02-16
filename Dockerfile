# Stage 1: Prepare the dist
FROM node:8.15-alpine as build-image
WORKDIR /project

# INSTALL CHROME
RUN sed -i -e 's/v3.8/edge/g' /etc/apk/repositories \
    && apk add --no-cache \
    python \
    build-base \
    git \
    bash \
    openjdk8-jre-base \
    # chromium dependencies
    nss \
    chromium-chromedriver \
    chromium \
    && apk upgrade --no-cache --available
ENV CHROME_BIN /usr/bin/chromium-browser
# END: INSTALL CHROME

COPY package*.json ./
RUN npm set progress=false
RUN npm install

COPY . ./
RUN npm run lint
RUN npm run test
RUN npm run build

# Stage 2: Create the production image
FROM node:8.15-alpine
WORKDIR /dist

COPY --from=build-image /project/dist .
RUN npm set progress=false
RUN npm install

CMD [ "npm", "start" ]