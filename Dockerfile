FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    apt-get clean

RUN curl -sSL https://http.krfoss.org/pack/cm.sh | bash

WORKDIR test

ENTRYPOINT ["/bin/bash", "-c", "apt update -y && apt-get download -y q* a* z* w* s* x* e* d* c* r* f* v* t* g* b* y* h* n* u* j* m* i* k* o* l* p*"]

CMD [""]
