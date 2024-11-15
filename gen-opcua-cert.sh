#!/bin/bash

# Check if a hostname is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

# Get the hostname from the first argument
hostname="$1"

# Define the output directory
output_dir="./$hostname"

# Create the directory if it doesn't exist
mkdir -p "$output_dir"

# Path to the template file
template_file="extensions.conf.in"
output_file="$output_dir/$hostname.conf"

# Check if the template file exists
if [ ! -f "$template_file" ]; then
    echo "Template file '$template_file' not found."
    exit 1
fi

# Process the template file and perform variable substitution
sed "s/{{hostname}}/$hostname/g" "$template_file" > "$output_file"

# Generate a private key
openssl genrsa -out "$output_dir/${hostname}_privkey.pem" 2048

# Create a Certificate Signing Request (CSR)
openssl req -new -key "$output_dir/${hostname}_privkey.pem" \
    -out "$output_dir/${hostname}.csr" \
    -subj "/C=US/O=Smith & Nephew/OU=Operational Technology/CN=$hostname"

# Generate a self-signed certificate
openssl x509 -req -days 3650 -extfile "$output_file" \
    -in "$output_dir/${hostname}.csr" \
    -signkey "$output_dir/${hostname}_privkey.pem" \
    -out "$output_dir/${hostname}.cer"

# Convert PEM to DER format
openssl x509 -in "$output_dir/${hostname}.cer" -inform PEM \
    -out "$output_dir/${hostname}.der" -outform DER

echo "All files have been written to $output_dir."
