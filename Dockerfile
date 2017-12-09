FROM debian:stable-slim

MAINTAINER Blacs30 <github@lisowski-development.com>

ENV version=2017.7.2+ds-1 \
    short_version=2017.7.2

RUN set -x \
    && apt-get -y update \
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
    && echo deb http://repo.saltstack.com/apt/debian/9/amd64/archive/${short_version} stretch main | tee /etc/apt/sources.list.d/saltstack.list \
    && wget -q -O - https://repo.saltstack.com/apt/debian/9/amd64/archive/${short_version}/SALTSTACK-GPG-KEY.pub | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        salt-common=${version} \
        salt-master=${version} \
        salt-minion=${version} \
        salt-ssh=${version} \
        salt-cloud=${version} \
        salt-api=${version} \
        salt-syndic=${version} \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

RUN  set -x \
    && echo deb http://repo.saltstack.com/apt/debian/9/amd64/latest stretch main | tee /etc/apt/sources.list.d/saltstack.list \
    && wget -q -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        salt-doc \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/log/salt", "/srv/salt", "/var/www"]

EXPOSE 4505 4506 8000

# Show salt versions
RUN salt --versions

COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

CMD /docker-entrypoint.sh
