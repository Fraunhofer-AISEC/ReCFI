#===-----------------------------------------------------------------------===//
#
# Dockerfile to test RCFI.
#
#===----------------------------------------------------------------------===//

FROM ubuntu:18.04 as builder
LABEL maintainer "Oliver Braunsdorf <oliver.braunsdorf@aisec.fraunhofer.de>"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	build-essential \
    python \
	gdb \
    nano \
    net-tools \
    curl \
    time \
    python-pip


ENV HOME=/home/builder
RUN groupadd builder && useradd -m -g builder builder
USER builder

USER root
RUN apt-get install -y lsof
USER builder

WORKDIR /home/builder/llvm-project/

ENTRYPOINT ["/bin/bash"]


