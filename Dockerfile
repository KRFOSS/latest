FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    apt-get clean

RUN curl -sSL https://http.krfoss.org/pack/cm.sh | bash

WORKDIR app

ENTRYPOINT ["/bin/bash", "-c", "apt update -y && apt-get download -y q* w* e* r* t* y* u*"]

CMD [""]
