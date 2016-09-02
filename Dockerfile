FROM marcelocg/phoenix:latest
MAINTAINER Alexandre axrv Hervé <alexandre.herve9@gmail.com>

RUN apt-get update && apt-get install -y wget
ENV DOCKERIZE_VERSION v0.2.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /usr/src/app
ENV MIX_ENV prod

COPY mix.* /usr/src/app/
RUN yes | mix do deps.get --only prod

COPY package.json /usr/src/app/
RUN npm install

RUN mix local.rebar --force
RUN mix deps.compile --only prod

COPY . /usr/src/app/
RUN mix compile

RUN node_modules/brunch/bin/brunch build --production
RUN mix do compile
RUN mix phoenix.digest

CMD ["mix","phoenix.server"]
