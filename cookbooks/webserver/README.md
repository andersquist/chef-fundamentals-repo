# webserver

A simple cookbook for learning test driven infrastructure development on.

## Requirements

### Platform:

* Windows 2012 and later *

### Cookbooks:

* dependencies: iis and windows_firewall*

## Attributes

* `node['iis']['sites']` -  Defaults to `clowns` and `bears` on port 80 and 81 respectively.

## Recipes

* webserver::default

## License and Maintainer

Maintainer::  (<Anders Quist>)

License:: All rights reserved
