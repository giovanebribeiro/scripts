#!/bin/bash
##
# Author: Giovane Boaviagem Ribeiro
# Since: 29/08/2016
# File: copy-db-to-local.sh
#
# Copy collections from a mongodb instance to local instance
# PS: PLEASE EDIT copy-db-to-local.conf FILE BEFORE RUNNING!!
##

## Declare the collections associative array
declare -A collections

## Import the configurations
source $PWD/copy-db-to-local.conf

# execute the main loop
for collection in "${!collections[@]}"
do
  echo "$collection"
done

