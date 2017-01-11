#!/usr/bin/env bash

terraform $1 -var-file=./conf/vars_$2.tfvars -var-file=./conf/vars_$2_$3.tfvars -state=./states/state_$2_$3.tfstate
