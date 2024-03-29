FROM debian:11-slim

RUN mkdir -p /build && \
    apt-get update && \
    apt-get install -y build-essential libpcre3-dev libssl-dev zlib1g-dev git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY deb /build/deb
COPY build.sh /build/
WORKDIR /build
CMD ["/build/build.sh"]
