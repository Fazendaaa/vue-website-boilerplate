FROM node:alpine3.11 as INSTALLER
LABEL project="cosmicjs/vue-website-boilerplate"
LABEL contributor="Fazendaaa"

WORKDIR /usr/src
COPY package.json .
RUN npm install
COPY . .

FROM node:alpine3.11 as LINTER

WORKDIR /usr/src
COPY --from=INSTALLER /usr/src/ .
RUN npm run lint

FROM node:alpine3.11 as BUILDER

WORKDIR /usr/src
COPY --from=LINTER /usr/src/ .
RUN npm run build

FROM node:alpine3.11 as RUNNER

WORKDIR /usr/src/app
ENV HOST=0.0.0.0
EXPOSE 3000
COPY --from=BUILDER /usr/src/.nuxt ./.nuxt
COPY --from=BUILDER /usr/src/node_modules ./node_modules
COPY --from=BUILDER /usr/src/package.json ./package.json
ENTRYPOINT npm start
