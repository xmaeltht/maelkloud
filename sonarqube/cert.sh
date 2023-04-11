#!/bin/bash

if [ -z "$1" ]
then
  echo "Please provide a domain name"
  exit 1
fi

DOMAIN=$1

# Generate a private key
openssl genrsa -out "${DOMAIN}.key" 2048

# Create a Certificate Signing Request (CSR)
openssl req -new -key "${DOMAIN}.key" -out "${DOMAIN}.csr" -subj "/CN=${DOMAIN}/O=My Organization/C=US"

# Generate a self-signed certificate
openssl x509 -req -days 365 -in "${DOMAIN}.csr" -signkey "${DOMAIN}.key" -out "${DOMAIN}.crt"

# Remove the CSR file
rm "${DOMAIN}.csr"

echo "Generated ${DOMAIN}.key and ${DOMAIN}.crt"
