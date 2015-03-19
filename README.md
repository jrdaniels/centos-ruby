# centos-ruby

## Overview

There are the following images available:

* latest (= systemd-latest)
* latest-onbuild (= systemd-latest-onbuild)
* docker-latest
* docker-latest-onbuild
* systemd-latest
* systemd-latest-onbuild

## Further description of images

### All images

All images have the latest `ruby`-version installed. `gcc` and `make` are
installed to make is easier to install `rubygems`-with c extensions. At
`/etc/default/ruby.conf` is a file you can source in your scripts or use in
`EnvironmentFile`-entries in your systemd service files.

### "-onbuild"-images

On build images add a customization-rake-file to the image:

```docker
ONBUILD ADD script/customize.rake /tmp/customize.rake
ONBUILD RUN rake --rakefile /tmp/customize.rake
```

### "systemd-"-images

All `systemd-`-images have `systemd` installed. They should be run with
`systemd-nspawn`.

### "docker-"-images

All `docker-`-images are compatible with `docker`.
