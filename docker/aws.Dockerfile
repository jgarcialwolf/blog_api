ARG RUBY_VERSION=3.2.1
FROM ruby:$RUBY_VERSION-alpine

ARG DATABASE_HOST
ARG DATABASE_HOST_READ
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG REDIS_URL
ARG REDIS_PASSWORD
ARG RAILS_MASTER_KEY
ARG RAILS_ENV
ARG LW_CRM_APP_USER_PASSWORD

ENV BREAK_CACHE=20240306_01

# Dependencies
RUN apk add --update --no-cache bash build-base curl-dev gcompat git ncurses nodejs openssh postgresql-dev tzdata imagemagick imagemagick-dev imagemagick-libs yarn vips
RUN update-ca-certificates

# Env vars
ENV APP_PATH=/app
ENV RAILS_ENV=$RAILS_ENV
ENV LANG=C.UTF-8
ENV BUNDLE_FROZEN=1
ENV BUNDLE_JOBS=3
ENV BUNDLE_RETRY=3
ENV BUNDLE_WITHOUT=development:test
ENV RAILS_LOG_TO_STDOUT=true
ENV PATH=$APP_PATH/bin:$APP_PATH/node_modules/.bin:$PATH
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_MASTER_KEY="$RAILS_MASTER_KEY"
ENV REDIS_URL="$REDIS_URL"
ENV REDIS_PASSWORD="$REDIS_PASSWORD"
ENV LW_CRM_APP_USER_PASSWORD="$LW_CRM_APP_USER_PASSWORD"
ENV DATABASE_URL="postgres://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST/crmDB"

# Bundle install
WORKDIR $APP_PATH
COPY Gemfile .
COPY Gemfile.lock .
COPY vendor vendor
RUN bundle

# Npm
# COPY .npmrc .
# COPY package.json .
# COPY yarn.lock .
# RUN yarn

# Copy application
COPY . .

# Compile assets
# RUN rake assets:precompile

# Start server
EXPOSE 3000
CMD rails server -b 0.0.0.0