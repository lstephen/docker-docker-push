FROM debian:jessie
MAINTAINER Levi Stephen <levi.stephen@gmail.com>

RUN apt-get update && apt-get -y install curl git

RUN curl -sSL https://get.docker.com/ | sh

COPY docker-push.sh /usr/local/bin/docker-push.sh
RUN chmod +x /usr/local/bin/docker-push.sh

ENTRYPOINT ["docker-push.sh"]
CMD ["build"]
