#!/bin/sh

if [ "$1" = "user" ]; then
  if [ "$2" = "--ssl" ]; then
    curl -v -k -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
      --sslv3 --data-binary @test_json.txt https://localhost:8443/igoat/user
  else
    curl -v -X POST -H "Content-Type: application/json" -H "Accept: application/json" \
      --data-binary @test_json.txt http://localhost:8080/igoat/user
  fi
elif [ "$1" = "token" ]; then
  if [ "$2" = "--ssl" ]; then
    curl -v -k --sslv3 https://localhost:8443/igoat/token
  else
    curl -v http://localhost:8080/igoat/token
  fi
else
  echo "Usage: ./test_client.sh <endpoint> [--ssl]"
  exit 1
fi
