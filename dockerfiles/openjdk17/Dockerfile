FROM ubuntu:20.04

ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
RUN export JAVA_HOME

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

COPY ./assets/tini /tini
COPY ./assets/launch.sh /root

ENTRYPOINT ["/tini"]
CMD ["/root/launch.sh"]