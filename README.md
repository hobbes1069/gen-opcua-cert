# gen-opcua-cert
Simple scripts for generating self-signed certificates compatible with OPC UA servers

## Attributions
These scrips were developed using a combination of industry experts, Google, and ChatGPT.

## Requirements
OpenSSL

### Linux
Generally any distribution with the OpenSSL package installed should be sufficient. 

### Windows
The PowerShell script has only been tested with the OpenSSL packages supplied by Shining Light Productions:
https://slproweb.com/products/Win32OpenSSL.html

## Usage

Regardless of which OS you run the script on all of the output files will be written to a subdirectory the same as the hostname provided.

The following files will be present:
* A private key in PEM format.
* An exstensions configuration file (.conf)
* A certificate signing requires (CSR).
* A self-signed certificate in PEM (base64) format.
* A self-signed certificate in DER (binary) format.


### Linux/Bash
```
# gen-opcua-cert.sh <hostname>
```

### Windows
For windows, the OpenSSL package above runs under `cmd` but you may simiply start PowerShell prior to running the script:

```
>powershell
PS > .\gen-opcua-cert.ps1 -hostname "<hostname>"
```
