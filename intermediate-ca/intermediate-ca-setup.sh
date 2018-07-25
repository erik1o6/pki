#!/usr/bin/env bash
set -xe
#mkdir intermediate-ca
#cd intermediate-ca
cat << EOF > intermediate-ca-config.json
{
    "auth_keys": {
        "client": {
            "type": "standard",
            "key": "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
        },
        "server": {
            "type": "standard",
            "key": "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
        },
        "peer": {
            "type": "standard",
            "key": "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
        }
    },
    "signing": {
        "profiles": {
            "server": {
                "expiry": "8700h",
                "auth_key": "server",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "8700h",
                "auth_key": "client",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "8700h",
                "auth_key": "peer",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF
cat << EOF > intermediate-ca-csr.json
{
    "CN": "shadow-intermediate-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca intermediate-ca-csr.json | cfssljson -bare intermediate-ca
cfssl sign -ca ../root-ca/ca.pem -ca-key ../root-ca/ca-key.pem -config ../root-ca/root-ca-config.json -profile intermediate intermediate-ca.csr | cfssljson -bare intermediate-ca
cd ..