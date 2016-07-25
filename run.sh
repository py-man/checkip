#!/bin/bash --login
rvm use 2.0
/data/check-host.rb $1 $2 $3 $4 $5 $6
