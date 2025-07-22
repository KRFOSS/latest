FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV MIRROR_URL=http.krfoss.org

COPY init.sh .

WORKDIR /test

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates && \
    apt-get clean

ENTRYPOINT ["/bin/bash", "-c", "bash /init.sh && apt-get download -y a*"]

CMD [""]
