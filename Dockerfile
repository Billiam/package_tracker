FROM ruby:2.3.5

RUN apt-get update \
    && apt-get install -y postgresql-client-9.4 less \
    && rm -rf /var/lib/apt/lists/*

# Execute commands on cliniko's folder
WORKDIR /src/trackify

RUN gem install bundler -v 1.13.6

COPY Gemfile Gemfile.lock /src/trackify/
RUN bundle install --jobs 4

COPY . /src/trackify

# Run server by default
CMD bundle exec padrino s -h 0.0.0.0 -p 3000

# Expose running server
EXPOSE 3000
