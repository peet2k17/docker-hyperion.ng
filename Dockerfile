####################
# BASE IMAGE
####################
FROM ubuntu:18.04
ARG S6_OVERLAY_VERSION=3.1.2.1

MAINTAINER prc2k10@googlemail.com <prc2k10@googlemail.com>

####################
# INSTALLATIONS
####################
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
		wget \
		gnupg2

RUN wget -qO- https://apt.hyperion-project.org/hyperion.pub.key | gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://apt.hyperion-project.org/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hyperion.list

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y hyperion

# S6 overlay
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

EXPOSE 8090 8091 19333 19400 19445
VOLUME /config

CMD hyperiond -u /config