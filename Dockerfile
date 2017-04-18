FROM openjdk:8
MAINTAINER Kyle Leaders <kyle.leaders@avvo.com>

# install rvm and docker
RUN apt-get update && \
	apt-get install -y apt-transport-https && \
	echo 'deb     https://get.docker.io/ubuntu docker main' | tee /etc/apt/sources.list.d/docker.list && \
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 && \
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
	curl -sSL https://get.rvm.io | /bin/bash -s stable

RUN apt-get update && \
	apt-get -y upgrade

RUN apt-get install -y \
	autoconf \
	automake \
	bison \
	build-essential \
	chrpath \
	curl \
	git-core \
	imagemagick \
	libaspell-dev \
	libc6-dev \
	libfontconfig1 \
	libfontconfig1-dev \
	libfreetype6 \
	libfreetype6-dev \
	libgeos-dev \
	libgmp3-dev \
	libhunspell-dev \
	libmagic-dev \
	libmagick++-dev \
	libmysqlclient-dev \
	libreadline6 \
	libreadline6-dev \
	libsqlite3-dev \
	libssl-dev \
	libtool \
	libxft-dev \
	libxml2-dev \
	libxslt-dev \
	libyaml-dev \
	lxc-docker \
	mysql-client \
	ncurses-dev \
	nodejs \
	npm \
	openssh-client \
	openssh-server \
	openssl \
	pkg-config \
	sqlite3 \
	subversion \
	wkhtmltopdf \ 
	xvfb \
	zip \
	zlib1g \
	zlib1g-dev

# install ruby
RUN /bin/bash -l -c "rvm install ruby-2.2.2 && rvm install ruby-2.3.1" && \
	/bin/bash -l -c "rvm default do gem install bundler -v 1.10.5"

# install phantomjs - this is super slow...
RUN mkdir -p /usr/local/share && \
	wget -O - -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 | tar -xjC /usr/local/share && \
	ln -s /usr/local/share/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin

# symlink wkhtmltopdf
RUN echo 'xvfb-run --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf $*' > /usr/bin/wkhtmltopdf.sh && \
	chmod a+x /usr/bin/wkhtmltopdf.sh && \
	ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

# jenkins workspace
RUN mkdir -p /tmp/workspace /var/run/sshd && \
	chmod -R 777 /tmp/workspace && \
	mkdir -p /var/lib/jenkins/checkout && \
	chmod 777 /var/lib/jenkins/checkout && \
	chmod 755 /var/run/sshd && \
	useradd jenkins -md /home/jenkins -U

# set PATH env
ENV PATH /usr/local/rvm/bin:$PATH

# need to set the timezone to Pacific
RUN rm /etc/localtime && \
	ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# Forces non-interactve SSH connections to read the jenkins .bashrc
RUN mkdir -p /home/jenkins/.ssh \
	&& echo 'PermitUserEnvironment yes' | tee -a /etc/ssh/sshd_config \
	&& echo "BASH_ENV=/home/jenkins/.bashrc\nPATH=${PATH}" | tee /home/jenkins/.ssh/environment \
	&& chown -R jenkins:jenkins /home/jenkins \
	&& chmod go-wrx -R /home/jenkins/.ssh

ADD run.sh /

EXPOSE 22
CMD ["/run.sh"]
