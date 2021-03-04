FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get install -y build-essential libpq-dev nodejs

#Install Nodejs with NPM
RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y nodejs

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem update --system
RUN gem install bundler -v 2.0.1
ENV BUNDLER_VERSION 2.0.1
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]