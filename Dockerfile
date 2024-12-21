FROM ruby:3.3.6-alpine

LABEL Name=adventofcode Version=0.1.0

RUN apk add --update \
    build-base \
    git

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . /app
