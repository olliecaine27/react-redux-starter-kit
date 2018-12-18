# Stage 1 - the build process
FROM node:8.11.3-alpine as build-image
WORKDIR /source-code
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
# RUN npm run lint
# RUN npm run test
RUN npm run build

# Stage 2 - the production environment
FROM node:8.11.3-alpine
COPY --from=build-image /source-code/dist dist
WORKDIR /dist
RUN npm install
CMD [ "npm", "start" ]