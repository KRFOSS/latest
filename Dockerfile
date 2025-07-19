FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR test

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates curl

RUN curl -sSL https://http.krfoss.org/pack/cm.sh | bash && apt-get clean

ENTRYPOINT ["/bin/bash", "-c", "apt update -y && apt-get download -y a*"]

CMD [""]
