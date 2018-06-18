#
# Ubunut-based RoR + MySQL Stack
#
#
# Building:
# docker build -t kmrd/ror .
#
#
# Usage:
# ------------------
# OSX / Ubuntu:
# docker run -it --rm --name ror -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/ror
#
# Windows:
# docker run -it --rm --name ror -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/ror
#
#
FROM ubuntu:16.04
MAINTAINER David Reyes <david@thoughtbubble.ca>

# Environments vars
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive 

ENV RBENV_ROOT=/usr/local/rbenv
ENV PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin



#-----------------------#
# Installs              #
#-----------------------#


RUN apt-get update && \
    apt-get -y upgrade

RUN apt-get -y --fix-missing install \
      curl \
      git \
      nano \
      dos2unix \
      lsof \
      apt-utils \
			autoconf \
      bison \
      build-essential \
      libssl-dev \
      libyaml-dev \
      libreadline6-dev \
      zlib1g-dev \
      libncurses5-dev \
      libffi-dev \
      libgdbm3 \
      libgdbm-dev \
      libpq-dev \
      zsh


RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv \
    && echo '# rbenv setup' > /etc/profile.d/rbenv.sh \
    && echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
    && echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh \
    && echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh \
    && chmod +x /etc/profile.d/rbenv.sh

ENV RUBY_VERSION=2.3.1

# install ruby-build
RUN mkdir /usr/local/rbenv/plugins \
    && git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
    && /usr/local/rbenv/plugins/ruby-build/install.sh \
    && rbenv install ${RUBY_VERSION} \
    && rbenv global ${RUBY_VERSION} \
    && gem install bundler \
    && rbenv rehash


RUN gem install rails


# Install MySQL
ENV MYSQL_PASSWORD=root \
    MYSQL_USER=root

RUN echo "mysql-server mysql-server/root_password password ${MYSQL_PASSWORD}" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password_again password ${MYSQL_PASSWORD}" | debconf-set-selections && \
  apt-get -y install mysql-server-5.7 && \
  mkdir -p /var/lib/mysql && \
  mkdir -p /var/run/mysqld && \
  mkdir -p /var/log/mysql && \
  chown -R mysql:mysql /var/lib/mysql && \
  chown -R mysql:mysql /var/run/mysqld && \
  chown -R mysql:mysql /var/log/

RUN sed -i -e "$ a [client]\n\n[mysql]\n\n[mysqld]"  /etc/mysql/my.cnf && \
  sed -i -e "s/\(\[client\]\)/\1\ndefault-character-set = utf8/g" /etc/mysql/my.cnf && \
  sed -i -e "s/\(\[mysql\]\)/\1\ndefault-character-set = utf8/g" /etc/mysql/my.cnf && \
  sed -i -e "s/\(\[mysqld\]\)/\1\ninit_connect='SET NAMES utf8'\ncharacter-set-server = utf8\ncollation-server=utf8_unicode_ci\nbind-address = 0.0.0.0/g" /etc/mysql/my.cnf

VOLUME /var/lib/mysql

RUN service mysql start && \
    mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'


#   ENV MYSQL_ROOT_PASSWORD=root \
#       MYSQL_DATABASE=app \
#       MYSQL_USER=mysql \
#       MYSQL_PASSWORD=mysql \
#       MYSQL_USER_MONITORING=monitoring \
#       MYSQL_PASSWORD_MONITORING=monitoring \
#       MYSQL_DATA_DIR=/var/lib/mysql \
#       MYSQL_LOG_DIR=/var/log/mysq
#       # MYSQL_RUN_DIR=/run/mysqld \
#   
#   
#   
#   RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections && \
#       echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections && \
#       apt-get -y --fix-missing install \
#         mysql-server
#         # mysql-client
#       # mysql_secure_install && \
#       # mysqladmin -u root password root

# RUN chown -R mysql:mysql /var/lib/mysql

# VOLUME ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]


# Install PostgreSQL
# RUN apt-get -y --fix-missing install \
# 			postgresql \
# 			postgresql-contrib




# RUN /etc/init.d/mysql start



WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html
EXPOSE 3000

ADD entrypoint.sh /var/www/entrypoint.sh
RUN dos2unix /var/www/entrypoint.sh
RUN chmod +x /var/www/entrypoint.sh

ENTRYPOINT ["/var/www/entrypoint.sh"]
#CMD ["/bin/bash"]

