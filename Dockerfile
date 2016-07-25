FROM ubuntu:14.04
MAINTAINER Kevin Brannigan <kevin.brannigan@me.com>

RUN apt-get update && apt-get install -y ruby curl vim nmap libcurl3 libcurl3-gnutls libcurl4-openssl-dev
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -L https://get.rvm.io | bash -s stable
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN rm /usr/bin/ruby
RUN ln -s /usr/local/rvm/rubies/ruby-2.0.0-p648/bin/ruby /usr/bin/ruby
RUN /bin/bash -l -c "rvm use --default 2.0"
RUN /bin/bash -l -c "gem install ruby-nmap"
RUN /bin/bash -l -c "gem install ipaddress"
RUN /bin/bash -l -c "gem install curb"
RUN /bin/bash -l -c "gem install curl"
RUN mkdir -p /data
ADD . /data/
ENTRYPOINT ["/data/run.sh"]







