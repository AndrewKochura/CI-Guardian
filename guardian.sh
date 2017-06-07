#!/usr/bin/env bash

#########################
# The command line help #
#########################
display_help() {
    echo "Usage: $(basename "$0") [option...] [--filename file or folder] [--zip-password] [--openssl-key] [--openssl-iv]" >&2
    echo
    echo "   -h, --help             Show command line help"
    echo "   -v, --verbose          Show verbose logs, must be the first argument"
    echo "   -e, --encrypt          Encryption mode"
    echo "   -d, --decrypt          Decryption mode"
    echo "       --filename         Name of file or folder to process"
    echo "       --zip-password     Password for temporary zip archive is the next argument (default is 0000)"
    echo "       --openssl-key      key{64 chars} in hex(0-9,A-F) is the next argument"
    echo "       --openssl-iv       iv{32 chars} in hex(0-9,A-F) is the next argument"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

optspec=":hvedf:z:k:i:-:"

is_verbose=false
crypt_type="undefined"
file_name="undefined"
zip_password="0000"
openssl_key="undefined"
openssl_iv="undefined"

while getopts "$optspec" optchar; do
    case "$optchar" in
        -)
            case "${OPTARG}" in
                help)
                    display_help  # Call your function
                    ;;
                verbose)
                    is_verbose=true
                    ;;
                filename=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=${val}}
                    if [[ ${is_verbose} == true ]]; then echo "Parsing option: '--${opt}', value: '${val}'" >&2; fi
                    file_name=${val}
                    ;;
                zip-password=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=${val}}
                    if [[ ${is_verbose} == true ]]; then echo "Parsing option: '--${opt}', value: '${val}'" >&2; fi
                    zip_password=${val}
                    ;;
                openssl-key=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=${val}}
                    if [[ ${is_verbose} == true ]]; then echo "Parsing option: '--${opt}', value: '${val}'" >&2; fi
                    openssl_key=${val}
                    ;;
                openssl-iv=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=${val}}
                    if [[ ${is_verbose} == true ]]; then echo "Parsing option: '--${opt}', value: '${val}'" >&2; fi
                    openssl_iv=${val}
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    display_help
                    ;;
            esac;;
        h)
            display_help  # Call your function
            ;;
        v)
            is_verbose=true
            ;;
        e)
            crypt_type="encryption"
            ;;
        d)
            crypt_type="decryption"
            ;;
        :)
            printf "missing argument for -%s\n" "$OPTARG" >&2
            echo "$usage" >&2
            display_help
            ;;
        \?)
            printf "illegal option: -%s\n" "$OPTARG" >&2
            echo "$usage" >&2
            display_help
            ;;
  esac
done
shift $((OPTIND - 1))

if [ ${zip_password} == "0000" ]; then
    echo "Warning! Better define your own strong password for more secure" >&2
fi

if [ ${crypt_type} == "undefined" ]; then
    echo "You need define -d or -e parameter for decryption or encryption" >&2
    exit 1
fi

if [ ${file_name} == "undefined" ] || [ ${openssl_key} == "undefined" ] || [ ${openssl_iv} == "undefined" ]; then
    echo "Parameters 'filename', 'openssl-key', 'openssl-iv' is primary and can not be undefined" >&2
    exit 1
fi

if [ ${crypt_type} == "encryption" ]; then

    # Zip data:
    if [ ${is_verbose} == true ]; then
        zip -v -P ${zip_password} -r -X ${file_name}.zip ${file_name}
    else
        zip -P ${zip_password} -r -X ${file_name}.zip ${file_name}
    fi

    # Openssl encrypt:
    if [ ${is_verbose} == true ]; then
        openssl aes-256-cbc -e -K ${openssl_key} -iv ${openssl_iv} -in ${file_name}.zip -out ${file_name}.zip.enc -p
    else
        openssl aes-256-cbc -e -K ${openssl_key} -iv ${openssl_iv} -in ${file_name}.zip -out ${file_name}.zip.enc
    fi

    # Remove temp zip file
    rm ${file_name}.zip

elif [ ${crypt_type} == "decryption" ]; then

    # Openssl decrypt:
    if [ ${is_verbose} == true ]; then
        openssl aes-256-cbc -d -K ${openssl_key} -iv ${openssl_iv} -in ${file_name}.zip.enc -out ${file_name}.zip -p
    else
        openssl aes-256-cbc -d -K ${openssl_key} -iv ${openssl_iv} -in ${file_name}.zip.enc -out ${file_name}.zip
    fi

    # Unzip data:
    if [ ${is_verbose} == true ]; then
        unzip -v -P ${zip_password} ${file_name}.zip
    fi
    unzip -P ${zip_password} ${file_name}.zip

    # Remove temp zip file
    rm ${file_name}.zip

else
    echo "You need define -d or -e parameter for decryption or encryption" >&2
    exit 1
fi
