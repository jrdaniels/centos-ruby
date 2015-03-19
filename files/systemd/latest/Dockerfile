FROM feduxorg/centos:latest
MAINTAINER fedux.org

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.1

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

# Build environment for ruby and ruby gems
RUN yum install -y gcc make

# Build ruby
RUN yum install -y openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel \
  && mkdir -p /usr/src/ruby \
  && curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
  | tar -xjC /usr/src/ruby --strip-components=1 \
  && cd /usr/src/ruby \
  && autoconf \
  && ./configure --disable-install-doc \
  && make -j"$(nproc)" \
  && make install \
  && rm -r /usr/src/ruby

# Cleanup
RUN yum remove -y openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel || exit 0
RUN yum clean -y all

# Do not create documentation on gem install
RUN echo -e "install: --no-ri --no-rdoc\nupdate: --no-ri --no-rdoc" >> /usr/local/etc/gemrc

# Install bundler
ENV GEM_HOME /usr/local/
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
      && bundle config --global path "$GEM_HOME" \
      && bundle config --global bin "$GEM_HOME/bin"

# Do not create .bundle in apps directory
ENV BUNDLE_APP_CONFIG $GEM_HOME

# Add defaults file for ruby
ADD ruby.conf /etc/default/ruby.conf

WORKDIR /

CMD ["irb"]

# Enable networkd
#RUN ln -s  /usr/lib/systemd/system/systemd-networkd.service /etc/systemd/system/multi-user.target.wants/systemd-networkd.service
#RUN ln -s /usr/lib/systemd/system/systemd-networkd.socket /etc/systemd/system/sockets.target.wants/systemd-networkd.socket 

# Enable resolved
#RUN ln -s /usr/lib/systemd/system/systemd-resolved.service /etc/systemd/system/multi-user.target.wants/systemd-resolved.service 
