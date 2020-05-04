#!/bin/bash

terraform --help | tee terraform-help.txt

for I in apply init plan refresh taint output destroy; do
  terraform "${I}" --help | tee "terraform-${I}-help.txt"
done
