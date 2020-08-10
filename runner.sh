#!/bin/bash

set -e

DOCKER_IMAGE="${DOCKER_IMAGE:-cloudflared}"
TMP_TAG="${TMP_TAG:-dev}"
CLOUDFLARED_RELEASE="${CLOUDFLARED_RELEASE:-2020.7.4}"
DOWNLOAD_LINK="${DOWNLOAD_LINK:-https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_RELEASE}/cloudflared-linux-amd64}" 
DOCKER_REGISTRY="${DOCKER_REGISTRY:-thclpr}"
OPT="$1"
PWD=$(dirname $0)

download_argo() {
  curl -L  ${DOWNLOAD_LINK} -o cloudflared
}
# Validate
docker_build() {
  docker build -t ${DOCKER_IMAGE}:${TMP_TAG} .
}
# Build
docker_publish() {
  if ([ "$TRAVIS_BRANCH" == "master" ] || [ ! -z "$TRAVIS_TAG" ]) && 
      [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    docker login --username "$DOCKER_REGISTRY_LOGIN" "$DOCKER_REGISTRY_TOKEN"
    for tag in latest "${CLOUDFLARED_RELEASE}" ; do
        echo "Tagging $tag"
        docker tag ${DOCKER_IMAGE}:${TMP_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${tag}
        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${tag}       
    done
  fi



}

case $OPT in
    download)
      download_argo
      ;;
    build)
      docker_build
      ;;
    publish)
      docker_publish
      ;;      
esac