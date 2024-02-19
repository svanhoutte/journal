FROM ruby:3.1.2

RUN apt update && apt install -y nodejs git

RUN gem update --system
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app/bin/docker-run"]

ENV RAILS_SERVE_STATIC_FILES 1
ENV RAILS_LOG_TO_STDOUT 1

ADD Gemfile Gemfile.lock /app/

RUN bundle update --bundler
RUN bundle install
RUN git clone https://github.com/svanhoutte/wyze_garmin_sync.git

ADD . .

RUN bundle exec rake assets:precompile

RUN mkdir -p tmp/pids

COPY ./bin/docker-run.sh /usr/local/bin/docker-run.sh

RUN chmod 755 /usr/local/bin/docker-run.sh

ENTRYPOINT ["/bin/sh","/usr/local/bin/docker-run.sh"]
