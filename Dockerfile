ARG BUN_VERSION=1.2.2
FROM oven/bun:${BUN_VERSION}-slim as base

WORKDIR /app

ENV NODE_ENV=production

FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential node-gyp pkg-config python-is-python3

COPY --link bun.lock package.json ./
RUN bun install --ci

COPY --link frontend/bun.locck frontend/package.json ./frontend/
RUN cd frontend && bun install --ci

COPY --link . .

FROM base

COPY --from=build /app /app

EXPOSE 3000
CMD ["bun", "run", "start"]