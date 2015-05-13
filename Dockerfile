FROM evarga/jenkins-slave
MAINTAINER Jeff Ching <jching@avvo.com>

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get install -y build-essential
RUN apt-get install -y openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config

# install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable

# install ruby
RUN /bin/bash -l -c "rvm install ruby-2.2.2"

RUN apt-get install -y git-core libmysqlclient-dev mysql-client
RUN /bin/bash -l -c "rvm default do gem install bundler"

RUN apt-get install -y libaspell-dev

RUN mkdir -p /tmp/workspace
RUN chmod 777 /tmp/workspace

ADD run.sh /

EXPOSE 22

CMD /run.sh
