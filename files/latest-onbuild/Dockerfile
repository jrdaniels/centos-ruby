FROM feduxorg/centos-ruby:latest
MAINTAINER dev@fedux.org

ONBUILD ADD script/customize.rake /tmp/customize.rake
ONBUILD RUN rake --rakefile /tmp/customize.rake
