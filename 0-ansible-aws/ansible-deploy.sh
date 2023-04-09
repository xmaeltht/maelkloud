#!/bin/bash

# this script is to deploy my ansible playbook

ansible-playbook -i ansible_inventory.ini ansible-http.yml