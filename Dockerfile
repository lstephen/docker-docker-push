FROM debian:jessie
MAINTAINER Levi Stephen <levi.stephen@gmail.com>

RUN apt-get update && apt-get -y install git

COPY docker-push.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-push.sh

ENTRYPOINT ["docker-push.sh"]
CMD ["build"]
