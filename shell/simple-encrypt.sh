#!/bin/bash
set -euo pipefail

action="$1"
file="$2"

encrypt_file() {
  local in_file="$1"
  local out_file="${in_file}.enc"

  if [[ ! -f "$in_file" ]]; then
    echo "Input file does not exist: $in_file"
    return 1
  fi
  
  echo "Enter password for encryption:"
  read -s password

  if [[ -z "$password" ]]; then
    echo "Password cannot be empty."
    return 1
  fi

  if openssl enc -aes-256-cbc -salt -in "$in_file" -out "$out_file" -k "$password" -pbkdf2 -iter 100000; then
    echo "File encrypted successfully: $out_file"
    rm "$in_file"
    echo "Original file removed: $in_file"
  else
    echo "Encryption failed."
    return 1
  fi
}

decrypt_file() {
  local in_file="$1"
  local out_file="${in_file%.enc}"

  if [[ ! -f "$in_file" ]]; then
    echo "Encrypted file does not exist: $in_file"
    return 1
  fi

  echo "Enter password for decryption:"
  read -s password

  if [[ -z "$password" ]]; then
    echo "Password cannot be empty."
    return 1
  fi

  if openssl enc -d -aes-256-cbc -in "$in_file" -out "$out_file" -k "$password" -pbkdf2 -iter 100000; then
    echo "File decrypted successfully: $out_file"
    rm "$in_file"
    echo "Encrypted file removed: $in_file"
  else
    echo "Decryption failed."
    return 1
  fi
}

case "$action" in
  lock)
    encrypt_file "$file"
    ;;
  open)
    decrypt_file "$file"
    ;;
  *)
    echo "Usage: $0 {lock|open} <file>"
    exit 1
    ;;
esac
