FROM node:16.13.0-buster-slim AS build-stage

COPY ./ /distalk/
WORKDIR /distalk
RUN apt-get update && apt-get install -y --no-install-recommends \
  python \
  make \
  gcc \
  g++ \
  libc-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
# TODO：後にbuildも通す
# RUN npm ci && npm run build && npm prune --production
RUN npm ci && npm prune --production

FROM node:16.13.0-buster-slim

COPY --from=build-stage /distalk /distalk
WORKDIR /distalk

USER node
ENTRYPOINT ["node", "dist/distalk.js"]
