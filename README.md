# CI-Guardian

### Usage examples

Script available by the next URL:
```bash
CI_Guardian_URL="https://raw.githubusercontent.com/AndrewKochura/CI-Guardian/master/guardian.sh"
```

For execute without download you can use next command:
```bash
curl -s ${CI_Guardian_URL} | bash /dev/stdin [option...]
```

Options and arguments:
```
Usage: guardian.sh [options...] [--filename] [--zip-password] [--openssl-key] [--openssl-iv]
   -h, --help             Show command line help
   -v, --verbose          Show verbose logs, must be placed as the first argument
   -e, --encrypt          Encryption mode
   -d, --decrypt          Decryption mode
       --filename         Name of file or folder is the next argument
       --zip-password     Password for temporary zip archive is the next argument (default is 0000)
       --openssl-key      key{64 chars} in hex(0-9,A-F) is the next argument
       --openssl-iv       iv{32 chars} in hex(0-9,A-F) is the next argument
```
