FROM debian:buster

RUN apt-get update -y && \
    apt-get install -y mariadb-server mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/auto_db.sh /auto_db.sh


RUN chmod +x /auto_db.sh

ENTRYPOINT ["/auto_db.sh"]
