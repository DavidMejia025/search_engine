FROM ruby:2.5.5

# Set an environment variable where the Rails app is installed to inside of Docker image
#ENV RAILS_ROOT /negotiatus
#RUN mkdir -p $RAILS_ROOT

# Set working directory
  WORKDIR /

#  RUN apt-get update -y

# Adding gems
  COPY Gemfile Gemfile
#  COPY Gemfile.lock Gemfile.lock

  ENV GEM_HOME="/usr/local/bundle"
  ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

 # RUN gem update --system

  RUN bundle install

# Adding project files
COPY . /

EXPOSE 3000

#ENTRYPOINT ["/negotiatus/docker-entrypoint.sh"]
#CMD ["ruby", "engine.rb"]
