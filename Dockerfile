ARG RUBY_VERSION=2.7.1
FROM ruby:$RUBY_VERSION-alpine as hyrax-base

ARG DATABASE_APK_PACKAGE="postgresql-dev"
ARG EXTRA_APK_PACKAGES="git"

RUN apk --no-cache upgrade && \
  apk --no-cache add build-base \
  tzdata \
  nodejs \
  $DATABASE_APK_PACKAGE \
  $EXTRA_APK_PACKAGES

RUN addgroup -S --gid 101 app && \
  adduser -S -G app -u 1001 -s /bin/sh -h /app app
USER app

RUN gem update bundler

RUN mkdir -p /app/samvera/hyrax-webapp
WORKDIR /app/samvera/hyrax-webapp

COPY --chown=1001:101 ./bin /app/samvera
ENV PATH="/app/samvera:$PATH"

ENTRYPOINT ["hyrax-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]


FROM hyrax-base as hyrax

ARG APP_PATH=.
ARG BUNDLE_WITHOUT="development test"

ONBUILD COPY --chown=1001:101 $APP_PATH /app/samvera/hyrax-webapp
ONBUILD RUN bundle install --jobs "$(nproc)"


FROM hyrax-base as hyrax-engine-dev

ARG APP_PATH=.dassie
ARG BUNDLE_WITHOUT=

ENV HYRAX_ENGINE_PATH /app/samvera/hyrax-engine

COPY --chown=1001:101 $APP_PATH /app/samvera/hyrax-webapp
COPY --chown=1001:101 . /app/samvera/hyrax-engine

RUN bundle install --jobs "$(nproc)"
