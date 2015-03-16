FROM feduxorg/centos:latest
MAINTAINER fedux.org

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

# Build environment for ruby and ruby gems
RUN yum install -y gcc make

# Build environment for ruby
RUN yum install -y openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

# Build ruby
RUN install -d /tmp/ruby
RUN curl -L http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz | tar -xzf - -C /tmp/ruby --strip-components=1
WORKDIR /tmp/ruby
RUN ./configure --disable-install-rdoc
RUN make install
RUN echo -e "install: --no-ri --no-rdoc\nupdate: --no-ri --no-rdoc" >> /usr/local/etc/gemrc
RUN /usr/local/bin/gem install bundler

# Enable networkd
#RUN ln -s  /usr/lib/systemd/system/systemd-networkd.service /etc/systemd/system/multi-user.target.wants/systemd-networkd.service
#RUN ln -s /usr/lib/systemd/system/systemd-networkd.socket /etc/systemd/system/sockets.target.wants/systemd-networkd.socket 

# Enable resolved
#RUN ln -s /usr/lib/systemd/system/systemd-resolved.service /etc/systemd/system/multi-user.target.wants/systemd-resolved.service 

ADD ruby.conf /etc/default/ruby.conf

RUN rm -r /tmp/*

RUN yum remove -y openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel || exit 0
RUN yum clean -y all

WORKDIR /

CMD ["/usr/local/bin/irb"]
