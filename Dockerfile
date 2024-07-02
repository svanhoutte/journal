FROM ruby:3.3.0-alpine3.18

# for ubuntu based container RUN apt update && apt install -y nodejs
RUN apk update && apk add --no-cache build-base postgresql-dev nodejs npm

RUN gem update --system
RUN gem install bundler

RUN mkdir /dockerapp
WORKDIR /dockerapp

EXPOSE 3000

ENTRYPOINT ["/dockerapp/bin/docker-run"]

ENV RAILS_SERVE_STATIC_FILES 1
ENV RAILS_LOG_TO_STDOUT 1

ADD . .
ADD Gemfile Gemfile.lock /app/

RUN bundle update --bundler
RUN bundle install

RUN bundle exec rake assets:precompile

RUN mkdir -p tmp/pids
