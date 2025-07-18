FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    apt-get clean

RUN curl -sSL https://http.krfoss.org/pack/cm.sh | bash

ENTRYPOINT ["/bin/bash", "-c", "apt update -y && apt-get download -y python* npm openjdk* libnginx-mod-* linux-headers-* nvidia-drvier-* gnome*"]

CMD [""]
