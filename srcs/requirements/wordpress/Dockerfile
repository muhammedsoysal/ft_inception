FROM debian:buster

RUN apt-get update -y && \
    apt-get install -y php7.3-fpm php7.3-mysql curl mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY tools/auto_wp.sh /auto_wp.sh

RUN chmod +x /auto_wp.sh

ENTRYPOINT ["/auto_wp.sh"]


