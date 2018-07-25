#!/usr/bin/env bash
#!/usr/bin/env bash
set -xe
cat << EOF > client-csr.json
{
  "hosts": [
    	"shadow_client"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "San Francisco",
      "O": "My Awesome Company",
      "OU": "Data Services",
      "ST": "California"
    }
  ]
}

EOF
cat << EOF > client-config.json
{
   "auth_keys" : {
      "sand" : {
         "type" : "standard",
         "key" : "52abb3ac91971bb72bce17e7a289cd04476490b19e0d8eb7810dc42d4ac16c41"
      }
   },
   "remotes" : {
      "intermediate-ca" : "http://127.0.0.1:8888"
   },
   "signing" : {
      "default" : {
         "auth_remote" : {
            "remote" : "intermediate-ca",
            "auth_key" : "sand"
         }
      }
   }
}
EOF

#cfssl gencert -ca=../intermediate-ca/intermediate-ca.pem -ca-key=../intermediate-ca/intermediate-ca-key.pem --config=../intermediate-ca/intermediate-ca-config.json -profile=client client-csr.json | cfssljson -bare client
cfssl gencert -loglevel=0 -config client-config.json -profile client client-csr.json | cfssljson -bare client