#!/bin/bash

TORRSSEN2=latest # 0.9.54
TORRSSEN2_HASH=131ca5b55e986f2fba3ad43b23d1cf8747e4cfdf
DATE=`date +%y%m%d`
ARCH=`arch`

if [ ${ARCH} != "x86_64" ]; then
  rm -rf ./torrssen2
  git clone https://github.com/tarpha/torrssen2.git
  cd torrssen2
  git checkout ${TORRSSEN2_HASH}
  sudo docker build -f ../torrssen2.${ARCH}.Dockerfile -t tarpha/torrssen2:${TORRSSEN2} .
  cd ..
  rm -rf ./torrssen2
fi

sudo docker build -t banyazavi/tsharp:${ARCH} \
  --build-arg build_date=${DATE} \
  --build-arg version_torrssen2=${TORRSSEN2} \
  .
