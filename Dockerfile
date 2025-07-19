FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y
    apt-get install -y ca-certificates curl && \
    apt-get clean

RUN curl -sSL https://http.krfoss.org/pack/cm.sh | bash

WORKDIR test

ENTRYPOINT ["/bin/bash", "-c", "apt update -y && apt-get download -y a*"]

CMD [""]
