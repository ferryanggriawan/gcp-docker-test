FROM node:17 as builder

WORKDIR /app

COPY . .

RUN yarn install \
  --prefer-offline \
  --frozen-lockfile \
  --non-interactive \
  --production=false

RUN NODE_OPTIONS=--openssl-legacy-provider yarn build

RUN rm -rf node_modules && \
  NODE_ENV=production yarn install \
  --prefer-offline \
  --pure-lockfile \
  --non-interactive \
  --production=true

FROM node:17

WORKDIR /app

COPY --from=builder /app  .

ENV HOST=0.0.0.0
ENV PORT=8080
EXPOSE 8080

ARG VERSION
ENV VERSION ${VERSION:-0.0.0-dev}

CMD [ "yarn", "start" ]
