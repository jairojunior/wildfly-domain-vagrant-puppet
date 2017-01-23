#!/bin/bash

gem install r10k --no-ri --no-rdoc
r10k puppetfile install
vagrant up
