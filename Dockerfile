FROM debian:jessie

MAINTAINER Ian Hilt "ian.hilt@gmail.com"

WORKDIR /tmp

ADD https://www.dotdeb.org/dotdeb.gpg .

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key add dotdeb.gpg \
	&& apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
	&& echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y \
		ca-certificates \
		nginx \
		gettext-base \
    supervisor \
    php7.0-fpm \
    php7.0-curl \
    php7.0-gd \
    php7.0-imap \
    php7.0-json \
    php7.0-ldap \
    php7.0-mcrypt \
    php7.0-pgsql \
		php7.0-mysql \
    php7.0-sqlite \
    php7.0-xmlrpc \
	&& rm -rf /var/lib/apt/lists/* \

  # forward request and error logs to docker log collector \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \

  # modify some php-fpm settings \
  && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini \
  && sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php/7.0/fpm/php.ini \
  && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php/7.0/fpm/php.ini \
  && sed -i "s/;opcache.enable=0/opcache.enable=0/" /etc/php/7.0/fpm/php.ini \
  && usermod -u 1000 www-data \
  && mkdir /run/php

ADD ./scripts/install-composer.sh /install-composer.sh
ADD ./conf/nginx.conf /etc/nginx/nginx.conf
ADD ./conf/conf.d /etc/nginx/conf.d
ADD ./conf/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD ./scripts/run.sh /run.sh
ADD ./scripts/wait-for-it.sh /wait-for-it.sh
WORKDIR /usr/share/nginx/html
RUN /install-composer.sh && chmod a+x /run.sh

EXPOSE 80 443

COPY conf/supervisord.conf /etc/supervisord.conf

CMD ["/run.sh"]
