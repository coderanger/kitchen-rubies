kitchen-rubies
==============

A build lab for [omnibus-rubies](https://github.com/danielsdeleo/omnibus-rubies)
using [test-kitchen](http://kitchen.ci/).

To start a build just run `kitchen test -d always -p`. As with any test-kitchen
build, you can also give it a regex like `ruby-210.*` or `.*-ubuntu-1204` to
limit the platforms build. You will need the envionrment variables
`$AWS_ACCESS_KEY_ID` and `$AWS_SECRET_ACCESS_KEY` set so it can upload the
resulting packages to S3.

Run `kitchen list` for a full listing of the available builds.
