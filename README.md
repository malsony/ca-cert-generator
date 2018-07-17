# Simple CA/Certificate Generator

## Denpendency
  - OpenSSL required:
   
## Usage
  1. Generate a CA key pair:
  ```
  bash gen-ca.sh
  ```
  2. Generate a Certificate key pair:
  ```
  bash gen-cert.sh
  ```
  3. Copy or move `CA.crt` (default name of the CA) to your desktop computer and install it as one of "Trusted Root Certification Authorities";
 
  4. Copy or move the certificate and key file to your designated path of your webserver, and maybe restart your webserver application.
 
  5. Have fun!

***Note: Ignore the file extension when naming the CA/Certificates.***
