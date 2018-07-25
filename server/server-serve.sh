#!/usr/bin/env bash
cfssl serve -ca-key server-key.pem -ca server.pem -config server-auth-config.json -port=8889 -address=0.0.0.0