#===-----------------------------------------------------------------------===//
#
# Dockerfile to create reliable builds of LLVM with RCFI.
#
#===----------------------------------------------------------------------===//

FROM ubuntu:18.04 as builder
LABEL maintainer "Oliver Braunsdorf <oliver.braunsdorf@aisec.fraunhofer.de>"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	bash-completion \
	build-essential \
	ccache \
	clang \
	cmake \
	distcc \
	distcc-pump \
	dpkg-dev \
	git \
	llvm \
	m4 \
	ninja-build \
	python3 \
	vim \
	&& rm -rf /var/lib/apt/lists/*


ENV HOME=/home/builder
RUN groupadd builder && useradd -m -g builder builder


WORKDIR /home/builder/llvm-project/
RUN chown builder:builder .

USER builder
COPY build.sh .

ENTRYPOINT ["/bin/bash"]


