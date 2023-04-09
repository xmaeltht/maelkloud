#!/bin/bash

# This script is used to deploy aws infrastructure that ansible will use to interact with.

terraform init
terraform apply -auto-approve
