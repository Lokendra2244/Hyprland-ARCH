#!/bin/bash
set -e

# === 1. Set up working directory ===
mkdir -p ~/secureboot/keys
cd ~/secureboot/keys

# === 2. Generate Keys ===
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Platform Key/" -keyout PK.key -out PK.crt -days 3650 -nodes
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Key Exchange Key/" -keyout KEK.key -out KEK.crt -days 3650 -nodes
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=Signature Database/" -keyout DB.key -out DB.crt -days 3650 -nodes

# === 3. Convert to DER format ===
openssl x509 -in PK.crt -outform DER -out PK.cer
openssl x509 -in KEK.crt -outform DER -out KEK.cer
openssl x509 -in DB.crt -outform DER -out DB.cer

# === 4. Create .auth files ===
sign-efi-sig-list -k PK.key -c PK.crt PK PK.cer PK.auth
sign-efi-sig-list -k PK.key -c PK.crt KEK KEK.cer KEK.auth
sign-efi-sig-list -k KEK.key -c KEK.crt db DB.cer DB.auth

echo "✅ Keys and .auth files are ready in ~/secureboot/keys"
