# CI-Guardian

### Use example:
```bash
curl -s https://raw.githubusercontent.com/AndrewKochura/CI-Guardian/master/guardian.sh |
    bash /dev/stdin -d
    --filename=properties
    --zip-password=${encrypted_zip_password}
    --openssl-key=${encrypted_openssl_key}
    --openssl-iv=${encrypted_openssl_iv}
```
