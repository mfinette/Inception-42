FROM debian:11

ARG SQL_DATABASE=a
ARG SQL_USER=a
ARG SQL_PWD=a
ARG SQL_ROOT_PWD=a

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

RUN service mariadb start && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE}; \
    CREATE USER IF NOT EXISTS ${SQL_USER}@'localhost' IDENTIFIED BY '${SQL_PWD}'; \
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO ${SQL_USER}@'%' IDENTIFIED BY '${SQL_PWD}'; \
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PWD}'; \
    FLUSH PRIVILEGES;" && \
    mysqladmin -u root -p$SQL_ROOT_PWD shutdown


CMD ["mysqld_safe"]

EXPOSE 3306
