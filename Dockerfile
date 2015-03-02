FROM centos:latest
MAINTAINER fedux.org

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

# No mirror plugin
RUN sed -ir -e "s/enabled=1/enabled=0/" etc/yum/pluginconf.d/fastestmirror.conf

# Update all repos
RUN yum update -y

# Better editor for troubleshooting
RUN yum install -y vim

# Give systemd a try
RUN yum remove -y fakesystemd
RUN yum install -y systemd dhclient

# Set priorities for default repositories
RUN yum install -y yum-priorities
RUN sed -i -e '/\[base\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[updates\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[extras\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[centosplus\]/ a \priority=2' /etc/yum.repos.d/CentOS-Base.repo

# Make rpmforge work
RUN yum install -y curl
RUN curl -o /tmp/rpmforge.rpm -L http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RUN rpm -Uvh /tmp/rpmforge.rpm
RUN sed -i -e '/\[rpmforge\]/ a \priority=3' /etc/yum.repos.d/rpmforge.repo
RUN yum update -y

# Install tar
RUN yum install -y tar

# Build environment for ruby
RUN yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel make

# Build ruby
RUN curl -L http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz | tar -xzf - -C /tmp/
WORKDIR /tmp/ruby-2.2.0
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

RUN yum remove -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel make || exit 0
RUN yum clean -y all

WORKDIR /

CMD ["/usr/local/bin/irb"]
