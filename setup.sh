#!/bin/bash

gem install r10k --no-ri --no-rdock
r10k puppetfile install
vagrant up
