#!/usr/bin/env bash
set -xe
#mkdir root-ca
#cd root-ca
cat << EOF > root-ca-config.json
{
    "auth_keys": {
        "intermediate": {
            "type": "standard",
            "key": "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
        }
    },
    "signing": {
        "profiles": {
            "intermediate": {
                "usages": [
                    "signature",
                    "digital-signature",
                    "cert sign",
                    "crl sign"
                ],
                "auth_key": "intermediate",
                "expiry": "26280h",
                "ca_constraint": {
                    "is_ca": true,
                    "max_path_len": 0,
                    "max_path_len_zero": true
                }
            }
        }
    }
}
EOF
#CA is valid for 5 years
cat << EOF > root-ca-csr.json
{
    "CN": "shadow-root-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "87600h"
    }
}
EOF
cfssl genkey -initca root-ca-csr.json | cfssljson -bare ca
#cd ..