#!/bin/sh
for TAG in run-with-jre run-with-jlink run-with-native-image-glibc run-with-native-image-static; do
  docker build . -t tmp:$TAG --target $TAG
done
docker images tmp
