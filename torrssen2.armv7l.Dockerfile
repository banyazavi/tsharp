FROM node:current-alpine
ENV NODE_OPTIONS --openssl-legacy-provider
RUN mkdir /torrssen2
COPY . /torrssen2
WORKDIR /torrssen2/nuxt
#RUN apt install -y yarn
RUN yarn && yarn build --spa
#RUN npm install && npm run build -- --spa
RUN mkdir -p ../src/main/resources/static
RUN cp -R dist/* ../src/main/resources/static

FROM gradle:jdk8
RUN mkdir /torrssen2
WORKDIR /torrssen2
COPY --from=0 /torrssen2 .
RUN gradle bootjar

FROM debian:stable-slim
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales

RUN locale-gen C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jre-headless

COPY --from=1 /torrssen2/build/libs/torrssen2-*.jar torrssen2.jar
VOLUME [ "/root/data" ]
EXPOSE 8080
CMD [ "java", "-jar", "torrssen2.jar"]
