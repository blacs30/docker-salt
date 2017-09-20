FROM debian:latest

MAINTAINER Blacs30 <github@lisowski-development.com>

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install \
        python \
        apt-utils \
        python-yaml \
        python-m2crypto \
        python-crypto \
        python-pygit2 \
        msgpack-python \
        python-zmq \
        python-jinja2 \
        python-requests \
        gnupg \
        wget \
        man \
        less \
    && echo deb http://repo.saltstack.com/apt/debian/9/amd64/latest stretch main | tee /etc/apt/sources.list.d/saltstack.list \
    && wget -q -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        salt-common \
        salt-master \
        salt-minion \
        salt-ssh \
        salt-cloud \
        salt-doc \
        salt-api \
        salt-syndic \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/logs/salt", "/srv/salt", "/srv/www"]

EXPOSE 4505 4506 8000

# Show salt versions
RUN salt --versions

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

CMD /docker-entrypoint.sh    
