#!/bin/bash

# This script is used to check the connection between ansible and the host

ansible all -i ansible_inventory.ini -m ping

ansible all -i ansible_inventory.ini -m command -a "uptime"