#!/usr/bin/env bash
set -xe
cat << EOF > server-csr.json
{
  "CN": "shadow-server",
  "hosts": [
    "ubuntu",
    "192.168.121.230",
    "localhost",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF
cat << EOF > server-config.json
{
   "auth_keys" : {
      "sand" : {
         "type" : "standard",
         "key" : "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
      }
   },
   "remotes" : {
      "intermediate" : "http://127.0.0.1:8888"
   },
   "signing" : {
      "default" : {
         "auth_remote" : {
            "remote" : "intermediate",
            "auth_key" : "sand"
         }
      }
   }
}
EOF
cat << EOF > server-auth-config.json
{
    "auth_keys": {
        "client": {
            "type": "standard",
            "key": "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
        }
    },
    "signing": {
        "profiles": {
            "client": {
                "expiry": "8700h",
                "auth_key": "client",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            }
        }
    }
}
EOF
#cfssl gencert -ca=../intermediate-ca/intermediate-ca.pem -ca-key=../intermediate-ca/intermediate-ca-key.pem --config=../intermediate-ca/intermediate-ca-config.json -profile=server server-csr.json | cfssljson -bare server
cfssl gencert -loglevel=0 -config server-config.json -profile server server-csr.json | cfssljson -bare server