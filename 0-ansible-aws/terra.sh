#!/bin/bash

# This script is used to deploy aws infrastructure that ansible will use to interact with.

terraform init
terraform apply -auto-approve

# This is used to check the connection between ansible and the host

ansible all -i ansible_inventory.ini -m ping

