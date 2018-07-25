#!/usr/bin/env bash
cfssl serve -ca-key intermediate-ca-key.pem -ca intermediate-ca.pem -config intermediate-ca-config.json -address=0.0.0.0